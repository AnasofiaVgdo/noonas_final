document.getElementById("loginForm").addEventListener("submit", function(e) {
    e.preventDefault();

    const username = document.getElementById("username").value;
    const password = document.getElementById("password").value;

    const data = new URLSearchParams();
    data.append("grant_type", "");
    data.append("username", username);
    data.append("password", password);
    data.append("scope", "");
    data.append("client_id", "");
    data.append("client_secret", "");

    fetch("http://127.0.0.1:8000/api/auth/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "accept": "application/json"
        },
        body: data
    })
    .then(response => response.json())
    .then(data => {
        console.log(data);

        if (data.access_token) {
            document.getElementById("mensaje").textContent = "Login exitoso ✅";

            // Guardar token
            localStorage.setItem("token", data.access_token);
            

        } else {
            document.getElementById("mensaje").textContent = "Error en login ❌";
        }
    })
    .catch(error => {
        console.error("Error:", error);
        document.getElementById("mensaje").textContent = "Error de conexión";
    });
});