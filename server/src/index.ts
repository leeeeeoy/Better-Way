// 상단에 인터페이스 정의
interface ActionRequest {
	deviceId: string;
	actionType: string;
}

interface CalculationLogRequest {
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
	netProfit: number;
	margin: number;
	monthlyProfit: number;
}

export default {
	async fetch(request: Request, env: any): Promise<Response> {
		const url = new URL(request.url);

		// CORS Preflight Request handling
		if (request.method === "OPTIONS") {
			return new Response(null, {
				headers: {
					"Access-Control-Allow-Origin": "*",
					"Access-Control-Allow-Methods": "POST, GET, OPTIONS",
					"Access-Control-Allow-Headers": "Content-Type",
					"Access-Control-Max-Age": "86400",
				},
			});
		}

		// 1. 미션 완료 기록 저장 (POST /api/action)
		if (request.method === "POST" && url.pathname === "/api/action") {
			const body = await request.json() as ActionRequest;

			const { deviceId, actionType } = body;

			if (!deviceId || !actionType) {
				return new Response(JSON.stringify({ error: "Missing deviceId or actionType" }), {
					status: 400,
					headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
				});
			}

			await env.DB.prepare(
				"INSERT INTO user_actions (device_id, action_type) VALUES (?, ?)"
			).bind(deviceId, actionType).run();

			return new Response(JSON.stringify({ success: true }), {
				headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
			});
		}

		// 2. 전체 카운트 조회 (GET /api/stats)
		if (url.pathname === "/api/stats") {
			const total = await env.DB.prepare("SELECT COUNT(*) as count FROM user_actions").first();
			return new Response(JSON.stringify(total), {
				headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
			});
		}

		// 3. 계산 로그 저장 (POST /api/log_calculation)
		if (request.method === "POST" && url.pathname === "/api/log_calculation") {
			let body: CalculationLogRequest;
			try {
				body = await request.json() as CalculationLogRequest;
			} catch (e) {
				return new Response(JSON.stringify({ error: "Invalid JSON body" }), {
					status: 400,
					headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
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
				netProfit,
				margin,
				monthlyProfit,
			} = body;

			// Basic validation
			const requiredFields = [
				clientId, sellingPrice, discountRate, costPrice, shippingCost,
				packagingCost, adCost, platformFeeRate, paymentFeeRate, quantity,
				netProfit, margin, monthlyProfit,
			];
			if (requiredFields.some(field => typeof field === 'undefined' || field === null)) {
				return new Response(JSON.stringify({ error: "Missing required fields" }), {
					status: 400,
					headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
				});
			}

			// Further validate that numbers are indeed numbers
			const numberFields = [
				sellingPrice, discountRate, costPrice, shippingCost,
				packagingCost, adCost, platformFeeRate, paymentFeeRate, quantity,
				netProfit, margin, monthlyProfit,
			];
			if (numberFields.some(field => typeof field !== 'number')) {
				return new Response(JSON.stringify({ error: "Invalid number format for one or more fields" }), {
					status: 400,
					headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
				});
			}


			await env.DB.prepare(
				`INSERT INTO calculation_logs (
					client_id, selling_price, discount_rate, cost_price, shipping_cost,
					packaging_cost, ad_cost, platform_fee_rate, payment_fee_rate, quantity,
					net_profit, margin, monthly_profit
				) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`
			).bind(
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
				netProfit,
				margin,
				monthlyProfit,
			).run();

			return new Response(JSON.stringify({ success: true }), {
				headers: { "Content-Type": "application/json", "Access-Control-Allow-Origin": "*" }
			});
		}

		return new Response("Not Found", { status: 404 });
	},
};
