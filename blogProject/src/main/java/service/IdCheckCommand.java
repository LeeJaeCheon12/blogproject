package service;

import java.io.IOException;
import java.io.PrintWriter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MemberDao;

public class IdCheckCommand implements Command {

	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("utf-8");
		String id = request.getParameter("id");
		MemberDao dao = new MemberDao();
		boolean isDuplicate = dao.idCheck(id);

		// json 형태로 직접 응답
		// JSON은 데이터를 서버와 클라이언트 가 주고 받기 위해 사용하는 문자열
		/* JSON형식의 데이터 "키:값"
		 * JSON { "name":"홍길동", "age":20, "phone":"010" }
		 */
		response.setContentType("application/json, charset=utf-8");
		// 응답의 종류를 알려주는 것, 내가 보내는 응답은 json, 문자는 utf-8로 읽어라
		PrintWriter out = response.getWriter();
		// 서버가응답할 통로 객체, HTM,JSON 같은 문자열로 클라이언트에게 보내는 도구
		out.print("{\"isDuplicate\":" + isDuplicate + "}");
		// JSON형식의 데이터, 실제로 만들어지는 문자열 ("isDuplicate" : true)
		return false;
	}

}
