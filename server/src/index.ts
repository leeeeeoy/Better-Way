// 상단에 인터페이스 정의
interface ActionRequest {
	deviceId: string;
	actionType: string;
}

export default {
	async fetch(request: Request, env: any): Promise<Response> {
		const url = new URL(request.url);

		// 1. 미션 완료 기록 저장 (POST /api/action)
		if (request.method === "POST" && url.pathname === "/api/action") {
			const body = await request.json() as ActionRequest;

			const { deviceId, actionType } = body;;

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

		return new Response("Not Found", { status: 404 });
	},
};