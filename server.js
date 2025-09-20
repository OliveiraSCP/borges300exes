const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);
const io = new Server(server);

const PORT = process.env.PORT || 3000;

// Servir arquivos estáticos da pasta /public
app.use(express.static(__dirname + "/public"));

// Armazena as salas em memória
const rooms = {}; // { roomId: { players: {}, messages: [] } }

// Função simples pra criar ID de sala
function makeId(len = 5) {
  return Math.random().toString(36).substr(2, len).toUpperCase();
}

// Conexão de usuário
io.on("connection", (socket) => {
  console.log("Novo usuário conectado:", socket.id);

  socket.on("createRoom", ({ name }) => {
    const roomId = makeId(4);
    rooms[roomId] = { players: {}, messages: [] };
    rooms[roomId].players[socket.id] = { id: socket.id, name };
    socket.join(roomId);
    socket.emit("roomCreated", { roomId });
    io.to(roomId).emit("updatePlayers", Object.values(rooms[roomId].players));
  });

  socket.on("joinRoom", ({ roomId, name }) => {
    if (!rooms[roomId]) {
      socket.emit("errorMsg", "Sala não existe.");
      return;
    }
    rooms[roomId].players[socket.id] = { id: socket.id, name };
    socket.join(roomId);
    io.to(roomId).emit("updatePlayers", Object.values(rooms[roomId].players));
  });

  socket.on("sendMessage", ({ roomId, text }) => {
    if (!rooms[roomId]) return;
    const player = rooms[roomId].players[socket.id];
    if (!player) return;
    const msg = { name: player.name, text };
    rooms[roomId].messages.push(msg);
    io.to(roomId).emit("newMessage", msg);
  });

  socket.on("disconnect", () => {
    for (const roomId in rooms) {
      const room = rooms[roomId];
      if (room.players[socket.id]) {
        delete room.players[socket.id];
        io.to(roomId).emit("updatePlayers", Object.values(room.players));
      }
    }
    console.log("Usuário saiu:", socket.id);
  });
});

server.listen(PORT, () => {
  console.log("Servidor rodando em http://localhost:" + PORT);
});
