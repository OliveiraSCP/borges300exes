// ===== CONFIGURE AQUI COM SEU FIREBASE =====
const firebaseConfig = {
  apiKey: "AIzaSyDlBleHcF6iHEVduvn9cOu_y9Qvf7zL-bs",
  authDomain: "bananatap-d9b9e.firebaseapp.com",
  projectId: "bananatap-d9b9e",
  storageBucket: "bananatap-d9b9e.firebasestorage.app",
  messagingSenderId: "554052738565",
  appId: "1:554052738565:web:ba7d56df29fe1bc26b066c",
  measurementId: "G-10FZKXZP64"
  };
  
firebase.initializeApp(firebaseConfig);
const auth = firebase.auth();
const db = firebase.database();

// ===== ELEMENTOS =====
const emailInput = document.getElementById("emailInput");
const userInput = document.getElementById("userInput");
const passInput = document.getElementById("passInput");
const loginError = document.getElementById("loginError");
const createAccountBtn = document.getElementById("createAccountBtn");
const loginBtn = document.getElementById("loginBtn");

const loginCard = document.getElementById("loginCard");
const mainMenu = document.getElementById("mainMenu");
const menuUser = document.getElementById("menuUser");

const startGameBtn=document.getElementById("startGameBtn");
const topGlobalBtn=document.getElementById("topGlobalBtn");
const shopBtn=document.getElementById("shopBtn");

const gameCard=document.getElementById("gameCard");
const rankingCard=document.getElementById("rankingCard");
const clicksSpan=document.getElementById("clicks");
const banana=document.getElementById("banana");
const exitGameBtn=document.getElementById("exitGameBtn");
const rankingList=document.getElementById("rankingList");
const backMenuBtn=document.getElementById("backMenuBtn");

let clicks=0;
let currentUser = null;

// ===== LOGIN / CADASTRO =====
createAccountBtn.onclick = ()=>{
  const email = emailInput.value.trim();
  const user = userInput.value.trim();
  const pass = passInput.value.trim();
  if(!email||!user||!pass){ loginError.innerText="Preencha todos os campos!"; return; }
  auth.createUserWithEmailAndPassword(email, pass)
    .then(res=>{
      db.ref('users/'+res.user.uid).set({user:user, clicks:0});
      loginError.innerText="Conta criada! Faça login.";
    })
    .catch(err=>loginError.innerText=err.message);
};

loginBtn.onclick = ()=>{
  const email=emailInput.value.trim();
  const pass=passInput.value.trim();
  auth.signInWithEmailAndPassword(email,pass)
    .then(res=>{
      currentUser = res.user;
      loginCard.classList.add("hidden");
      mainMenu.classList.remove("hidden");
      db.ref('users/'+currentUser.uid+'/user').once('value').then(snap=>{
        menuUser.innerText = snap.val();
      });
    })
    .catch(err=>loginError.innerText=err.message);
};

// ===== MENU =====
startGameBtn.onclick=()=>{
  mainMenu.classList.add("hidden");
  gameCard.classList.remove("hidden");
  startGame();
};

topGlobalBtn.onclick=()=>{
  mainMenu.classList.add("hidden");
  rankingCard.classList.remove("hidden");
  showRanking();
};

backMenuBtn.onclick=()=>{
  rankingCard.classList.add("hidden");
  mainMenu.classList.remove("hidden");
};

// ===== JOGO =====
function startGame(){
  clicks=0;
  clicksSpan.innerText=clicks;
  banana.onclick=()=>{
    clicks++;
    clicksSpan.innerText=clicks;
    banana.style.transform = `scale(${1+Math.random()*0.3}) rotate(${Math.random()*30-15}deg)`; 
    setTimeout(()=>{ banana.style.transform="scale(1) rotate(0deg)"; },200);
    db.ref('users/'+currentUser.uid+'/clicks').set(clicks);
  };
}

exitGameBtn.onclick=()=>{
  gameCard.classList.add("hidden");
  mainMenu.classList.remove("hidden");
};

// ===== RANKING GLOBAL =====
function showRanking(){
  rankingList.innerHTML="";
  db.ref('users').orderByChild('clicks').limitToLast(50).once('value', snap=>{
    let arr=[];
    snap.forEach(u=>arr.push(u.val()));
    arr.sort((a,b)=>b.clicks-a.clicks);
    arr.forEach(u=>{
      const li=document.createElement("li");
      li.innerText=`${u.user} - ${u.clicks} clicks`;
      rankingList.appendChild(li);
    });
  });
}
