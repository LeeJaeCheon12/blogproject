package controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import service.Command;
import service.IdCheckCommand;
import service.LoginCommand;
import service.LogoutCommand;
import service.MemberInsert;
import service.MypageCommand;

import java.io.IOException;

@WebServlet("/member/*")
// URL을 통해서 요청하는 주소가 /member로 시작하면 모든요청(*)은 이 클래스가 자동으로 실행
public class MemberController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	// 직렬화 관련 버전 번호

	public MemberController() {
		// 생성자
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			// doGet : get 방식으로 넘어온 데이터를 처리하는 메서드
			// request : 사용자가 보내온 데이터를 요청할 때 사용
			// response : 사용자가 처리한 데이터를 응답할 때 사용
			throws ServletException, IOException {

		doAction(request, response);

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doAction(request, response);

	}

	protected void doAction(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String pathInfo = request.getPathInfo();
		// localhost:8090/blogProject/member/join
		System.out.println("pathInfo :" + pathInfo);
		String page = null;

		Command command = null;

		switch (pathInfo) {
		case "/join": // localhost:8090/blogProject/member/join
			command = new MemberInsert(); // 다형성
			page = "/mem/join.jsp";
			break;
		case "/idCheck": // localhost:8090/blogProject/member/idCheck
			command = new IdCheckCommand();
			page = null;
			break;
		case "/login": // localhost:8090/blogProject/member/login
			command = new LoginCommand();
			page = "/mem/login.jsp";
			break;
		case "/logout":
			command = new LogoutCommand();
			page = null;
			break;
		case "/mypage":
			command = new MypageCommand();
			page = "/mem/mypage.jsp";
			break;
		}
		boolean needForward = command.doCommand(request, response);

		if (needForward && page != null) {
			RequestDispatcher rd = request.getRequestDispatcher(page);
			rd.forward(request, response);
		}
	}
}
