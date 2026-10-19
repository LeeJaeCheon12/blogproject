package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.BoardCommand;
import service.BoardDelete;
import service.BoardList;
import service.BoardModify;
import service.BoardView;
import service.Command;
import service.IndexCommand;
import service.LikeCommand;

@WebServlet("/blog/*")
@MultipartConfig(maxFileSize = 10 * 1024 * 1024, // 파일1개 최대 10MB
		maxRequestSize = 20 * 1024 * 1024 // 전체 요청 최대 20MB
)

public class BoardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public BoardController() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);
	}

	protected void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("requestURI : " + request.getRequestURI());
		System.out.println("contextPath : " + request.getContextPath());
		System.out.println("servletPath : " + request.getServletPath());
		System.out.println("pathInfo : " + request.getPathInfo());
		String pathInfo = request.getPathInfo();
		String page = null;
		Command command = null;
		switch (pathInfo) {
		case "/list":
			command = new BoardList();
			page = "/board/list.jsp";
			break;
		case "/write":
			command = new BoardCommand();
			page = "/board/Write.jsp";
			break;
		case "/view":
			command = new BoardView();
			page = "/board/view.jsp";
			break;
		case "/delete":
			command = new BoardDelete();
			page = null;
			break;
		case "/update":
			command = new BoardModify();
			page = "/board/modify.jsp";
			break;
		case "/like":
			command = new LikeCommand();
			page = null;
			break;

		case "/index":
			command = new IndexCommand();
			page = "/index.jsp";
			break;

		default:
			response.sendRedirect(request.getContextPath() + "/blog/list");
			return;
		}

		boolean needForward = command.doCommand(request, response);

		if (needForward && page != null) {
			request.getRequestDispatcher(page).forward(request, response);
		}
	}
}
