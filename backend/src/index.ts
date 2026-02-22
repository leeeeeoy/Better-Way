// 상단에 인터페이스 정의
interface CalculationInput {
	clientId: string;
	sellingPrice: number;
	discountRate: number;
	costPrice: number;
	shippingCost: number;
	packagingCost: number;
	adCost: number;
	platformFeeRate: number;
	paymentFeeRate: number;
	quantity: number;
}

interface ProfitResult {
	netProfit: number;
	margin: number;
	monthlyProfit: number;
}

/**
 * Rounds a number to a specified number of decimal places.
 * @param value The number to round.
 * @param decimals The number of decimal places to round to.
 * @returns The rounded number.
 */
function round(value: number, decimals: number): number {
	return Number(Math.round(Number(value + 'e' + decimals)) + 'e-' + decimals);
}


/**
 * Calculates profit metrics based on input values.
 * Follows the logic defined in GEMINI.md.
 */
function calculateProfit(input: Omit<CalculationInput, 'clientId'>): ProfitResult {
	const {
		sellingPrice: p,
		discountRate: d,
		costPrice: c,
		shippingCost: s,
		packagingCost: pk,
		adCost: a,
		platformFeeRate: f_p,
		paymentFeeRate: f_pg,
		quantity: q,
	} = input;

	// 1단계: 실제 판매가
	const p_real = p * (1 - d);

	// 2단계: 수수료 계산
	const f_total = f_p + f_pg;
	const fee = p_real * f_total;

	// 3단계: 부가세 계산
	const output_vat = p_real * (10 / 110);
	const input_vat = c * (10 / 110);
	const vat = Math.max(output_vat - input_vat, 0);

	// 4단계: 세전 영업이익
	const gross_profit = p_real - fee - c - s - pk - a;

	// 5단계: 최종 순이익
	const netProfit = gross_profit - vat;

	// 6단계: 마진율
	const margin = p_real > 0 ? netProfit / p_real : 0;

	// 7단계: 월 예상 순이익
	const monthlyProfit = netProfit * q;

	return {
		netProfit: round(netProfit, 2),
		margin: round(margin, 4),
		monthlyProfit: round(monthlyProfit, 2),
	};
}


export default {
	async fetch(request: Request, env: any): Promise<Response> {
		const url = new URL(request.url);

		// CORS Preflight Request handling
		if (request.method === 'OPTIONS') {
			return new Response(null, {
				headers: {
					'Access-Control-Allow-Origin': '*',
					'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
					'Access-Control-Allow-Headers': 'Content-Type',
					'Access-Control-Max-Age': '86400',
				},
			});
		}

		// 계산 로그 저장 (POST /api/log_calculation)
		if (request.method === 'POST' && url.pathname === '/api/log_calculation') {
			let body: CalculationInput;
			try {
				body = await request.json();
			} catch (e) {
				return new Response(JSON.stringify({ error: 'Invalid JSON body' }), {
					status: 400,
					headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
				});
			}

			const {
				clientId,
				sellingPrice,
				discountRate,
				costPrice,
				shippingCost,
				packagingCost,
				adCost,
				platformFeeRate,
				paymentFeeRate,
				quantity,
			} = body;

			// Basic validation
			const requiredFields = [
				clientId, sellingPrice, discountRate, costPrice, shippingCost,
				packagingCost, adCost, platformFeeRate, paymentFeeRate, quantity,
			];
			if (requiredFields.some(field => typeof field === 'undefined' || field === null)) {
				return new Response(JSON.stringify({ error: 'Missing required fields' }), {
					status: 400,
					headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
				});
			}

			// 서버에서 직접 계산 수행
			const { netProfit, margin, monthlyProfit } = calculateProfit({
				sellingPrice, discountRate, costPrice, shippingCost, packagingCost,
				adCost, platformFeeRate, paymentFeeRate, quantity,
			});

			try {
				await env.DB.prepare(
					`INSERT INTO calculation_logs (
						client_id, selling_price, discount_rate, cost_price, shipping_cost,
						packaging_cost, ad_cost, platform_fee_rate, payment_fee_rate, quantity,
						net_profit, margin, monthly_profit
					) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
					ON CONFLICT(client_id) DO UPDATE SET
						selling_price = excluded.selling_price,
						discount_rate = excluded.discount_rate,
						cost_price = excluded.cost_price,
						shipping_cost = excluded.shipping_cost,
						packaging_cost = excluded.packaging_cost,
						ad_cost = excluded.ad_cost,
						platform_fee_rate = excluded.platform_fee_rate,
						payment_fee_rate = excluded.payment_fee_rate,
						quantity = excluded.quantity,
						net_profit = excluded.net_profit,
						margin = excluded.margin,
						monthly_profit = excluded.monthly_profit,
						updated_at = CURRENT_TIMESTAMP`
				).bind(
					clientId, sellingPrice, discountRate, costPrice, shippingCost,
					packagingCost, adCost, platformFeeRate, paymentFeeRate, quantity,
					netProfit, margin, monthlyProfit,
				).run();

				return new Response(JSON.stringify({ success: true, message: 'Calculation saved.' }), {
					headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
				});

			} catch (error: any) {
				return new Response(JSON.stringify({ error: 'Failed to save calculation log.', details: error.message }), {
					status: 500,
					headers: { 'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*' },
				});
			}
		}

		return new Response('Not Found', { status: 404 });
	},
};
