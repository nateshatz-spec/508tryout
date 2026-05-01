export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    
    // Simple endpoint to save an API credential
    if (url.pathname === "/api/save-credential" && request.method === "POST") {
      const { userId, platform, key, value } = await request.json();
      
      await env.DB.prepare(
        "INSERT INTO api_credentials (user_id, platform_name, credential_key, credential_value) VALUES (?, ?, ?, ?)"
      ).bind(userId, platform, key, value).run();
      
      return new Response("Saved", { status: 200 });
    }

    // Simple endpoint to get logs
    if (url.pathname === "/api/logs") {
      const { results } = await env.DB.prepare("SELECT * FROM agent_logs ORDER BY timestamp DESC LIMIT 50").all();
      return new Response(JSON.stringify(results), {
        headers: { "Content-Type": "application/json" }
      });
    }

    return new Response("508 Agency API is Live", { status: 200 });
  }
};
