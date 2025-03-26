const loginForm = document.getElementById('login-form');
const appContainer = document.getElementById('app-container');
const cameraScreen = document.getElementById('camera');
const usernameInput = document.getElementById('username');
const passwordInput = document.getElementById('password');

// Função que verifica o login
loginForm.addEventListener('submit', function (e) {
    e.preventDefault();

    const username = usernameInput.value;
    const password = passwordInput.value;

    // Lógica de validação com o novo login
    if (username === 'Kaynã' && password === 'Developer') {
        // Mostra o app
        appContainer.classList.remove('hidden');
        loginForm.reset();
        iniciarCamera();
    } else {
        alert('Login ou senha incorretos!');
    }
});

// Função para iniciar a câmera
function iniciarCamera() {
    navigator.mediaDevices.getUserMedia({ video: true })
        .then((stream) => {
            cameraScreen.srcObject = stream;
        })
        .catch((error) => {
            console.error('Erro ao acessar a câmera: ', error);
        });
}
