<%
Dim mensaje, procesando, colorResultado
mensaje = ""
procesando = False
colorResultado = "red"

If Request.Form("accion") = "procesar" Then
    procesando = True

    ' Simular espera de 10 segundos
    Dim startTime, currentTime
    startTime = Timer

    Do
        currentTime = Timer
        If currentTime < startTime Then
            currentTime = currentTime + 86400 ' Manejo del cambio de día si el tiempo pasa la medianoche
        End If
    Loop While (currentTime - startTime) < 10

    mensaje = "¡Procesamiento finalizado después de 10 segundos!"
    colorResultado = "black"
End If
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ASP clásico - Demora simulada</title>
    <style>
        #resultado {
            font-weight: bold;
        }
    </style>
    <script>
        function mostrarProcesando() {
            var resultado = document.getElementById("resultado");
            resultado.style.color = "red";
            resultado.innerHTML = "Procesando... por favor espere 10 segundos.";
            return true; // Permitir que el formulario se envíe
        }
    </script>
</head>
<body>
    <h2>Simulación de demora en ASP clásico</h2>

    <form method="post" action="demo1.asp" onsubmit="return mostrarProcesando()">
        <input type="hidden" name="accion" value="procesar" />
        <button type="submit">Iniciar proceso</button>
    </form>

    <p id="resultado" style="color:<%= colorResultado %>;">
        <% If procesando Then %>
            <%= mensaje %>
        <% End If %>
    </p>
</body>
</html>