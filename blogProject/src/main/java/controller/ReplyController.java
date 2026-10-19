package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.Command;
import service.ReplyDelete;
import service.ReplyModify;
import service.ReplyWrite;

import java.io.IOException;

@WebServlet("/reply/*")
public class ReplyController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public ReplyController() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8"); // 한글 댓글 깨짐 방지
		doAction(request, response);
	}

	protected void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String pathInfo = request.getPathInfo();
		System.out.println("pathInfo : " + pathInfo);
		Command command = null;

		switch (pathInfo) {
		case "/write":
			command = new ReplyWrite();

			break;
		case "/delete":
			command = new ReplyDelete();
			break;
		case "/modify":
			command = new ReplyModify();
			break;
		}
		command.doCommand(request, response);
		// 모든 reply 기능은 Ajax라 forward할 page가 없다
	}

}
