let contract;
let signer;

const contractAddress = "YOUR_CONTRACT_ADDRESS"; // Replace with deployed contract address

async function connect() {
  if (window.ethereum) {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    await provider.send("eth_requestAccounts", []);
    signer = provider.getSigner();
    contract = new ethers.Contract(contractAddress, abi, signer);
    console.log("Connected to contract");
  } else {
    alert("MetaMask not detected!");
  }
}

async function registerArt() {
  const title = document.getElementById("title").value;
  const artist = document.getElementById("artist").value;
  const imageHash = document.getElementById("imageHash").value;

  try {
    const tx = await contract.registerArt(title, artist, imageHash);
    await tx.wait();
    alert("Artwork registered!");
  } catch (err) {
    console.error(err);
    alert("Error registering artwork");
  }
}

async function getAllArts() {
  try {
    const arts = await contract.getAllArts();
    const list = document.getElementById("artList");
    list.innerHTML = "";
    arts.forEach((art) => {
      const li = document.createElement("li");
      li.textContent = `#${art.id} | ${art.title} by ${art.artistName} | Owner: ${art.currentOwner}`;
      list.appendChild(li);
    });
  } catch (err) {
    console.error(err);
  }
}

connect(); // Auto-connect on load
