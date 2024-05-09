package xpec;
import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/add")
public class AddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        // Retrieving form data
        int num1 = Integer.parseInt(request.getParameter("num1"));
        int num2 = Integer.parseInt(request.getParameter("num2"));
        String op = request.getParameter("op");
        
        // Performing calculation based on the operand
        int result = 0;
        if(op.equals("+")) {
            result = num1 + num2;
        } else if(op.equals("-")) {
            result = num1 - num2;
        } else if(op.equals("*")) {
            result = num1 * num2;
        } else if(op.equals("/")) {
            result = num1 / num2;
        }
        
        // Displaying result
        out.println("<html>");
        out.println("<head><title>Result</title>");
        out.println("<style>");
        out.println("body { text-align: center; margin-top: 50px; }");
        out.println("h2 { color: blue; }");
        out.println("p { font-size: 20px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h2>Result:</h2>");
        out.println("<p>" + num1 + " " + op + " " + num2 + " = " + result + "</p>");
        out.println("</body></html>");
    }
}
