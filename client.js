const socket = io();

// Elementos
const loginDiv = document.getElementById("login");
const roomDiv = document.getElementById("room");
const nameInput = document.getElementById("nameInput");
const roomInput = document.getElementById("roomInput");
const joinBtn = document.getElementById("joinBtn");
const errorMsg = document.getElementById("errorMsg");

const roomIdSpan = document.getElementById("roomId");
const playersList = document.getElementById("playersList");
const msgInput = document.getElementById("msgInput");
const sendBtn = document.getElementById("sendBtn");
const messagesDiv = document.getElementById("messages");

let currentRoom = null;

// Entrar ou criar sala
joinBtn.onclick = () => {
  const name = nameInput.value.trim();
  const roomId = roomInput.value.trim();
  if (!name) {
    errorMsg.innerText = "Digite seu nome!";
    return;
  }
  if (roomId) {
    socket.emit("joinRoom", { roomId, name });
    currentRoom = roomId;
  } else {
    socket.emit("createRoom", { name });
  }
};

// Criou sala
socket.on("roomCreated", ({ roomId }) => {
  currentRoom = roomId;
  showRoom(roomId);
});

// Entrou na sala
socket.on("updatePlayers", (players) => {
  playersList.innerHTML = "";
  players.forEach(p => {
    const li = document.createElement("li");
    li.textContent = p.name;
    playersList.appendChild(li);
  });
});

socket.on("newMessage", (msg) => {
  const div = document.createElement("div");
  div.innerHTML = `<b>${msg.name}:</b> ${msg.text}`;
  messagesDiv.appendChild(div);
  messagesDiv.scrollTop = messagesDiv.scrollHeight;
});

socket.on("errorMsg", (msg) => {
  errorMsg.innerText = msg;
});

// Enviar mensagem
sendBtn.onclick = () => {
  const text = msgInput.value.trim();
  if (text && currentRoom) {
    socket.emit("sendMessage", { roomId: currentRoom, text });
    msgInput.value = "";
  }
};

function showRoom(roomId) {
  loginDiv.classList.add("hidden");
  roomDiv.classList.remove("hidden");
  roomIdSpan.innerText = roomId;
}
