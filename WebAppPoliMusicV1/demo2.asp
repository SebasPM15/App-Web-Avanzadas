<%
' Detectar si se hizo una petición fetch (AJAX)
If Request.ServerVariables("HTTP_X_REQUESTED_WITH") = "XMLHttpRequest" Then
   ' Simular espera de 10 segundos usando Timer
   Dim startTime, currentTime
   startTime = Timer
   Do
       currentTime = Timer
       If currentTime < startTime Then
           currentTime = currentTime + 86400 ' Manejo de rollover
       End If
   Loop While (currentTime - startTime) < 10
  Response.ContentType = "text/plain"
   Response.Write "¡Procesamiento finalizado tras 10 segundos!"
   Response.End
End If
%>
<!DOCTYPE html>
<html>
<head>
   <meta charset="utf-8">
   <title>ASP Clásico - Simulación de Demora con AJAX</title>
   <script>
       function llamarASP() {
           const resultado = document.getElementById("resultado");
          resultado.style.color = "red";
          resultado.innerText = "Procesando... espere 10 segundos.";
          fetch("demo2.asp", {
               method: "GET",
              headers: {
                  "X-Requested-With": "XMLHttpRequest"
               }
           })
          .then(response => response.text())
           .then(data => {
              resultado.style.color = "black";
               resultado.innerText = data;
           })
          .catch(error => {
              resultado.style.color = "red";
              resultado.innerText = "Error: " + error;
           });
       }
   </script>
</head>
<body>
   <h2>Simulación de procesamiento lento en ASP clásico</h2>
   <button onclick="llamarASP()">Iniciar proceso</button>
   <p id="resultado"></p>
</body>
</html>