<%
' Clear the current session
Session.Abandon

' Redirect to a login page or any other page after logout
Response.Redirect "login.asp"
%>
