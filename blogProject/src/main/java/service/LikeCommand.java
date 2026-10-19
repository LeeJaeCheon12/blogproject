package service;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.LikeDao;
import model.MemberDto;

public class LikeCommand implements Command {

	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		HttpSession session = request.getSession();
		MemberDto dto = (MemberDto) session.getAttribute("loginMember");

		Map<String, Object> result = new HashMap<String, Object>();
		if (dto == null) {
			result.put("success", false);
			result.put("message", "로그인이 필요합니다");
			sendJson(response, result);
			return false;
		}
		int bno = Integer.parseInt(request.getParameter("bno"));
		LikeDao dao = new LikeDao();
		dao.toggle(bno, dto.getId());
		result.put("success", true);
		result.put("liked", dao.isLiked(bno, dto.getId()));
		result.put("likeCount", dao.selectLikeCnt(bno));
		sendJson(response, result);
		return false;
	}

	private void sendJson(HttpServletResponse response, Map<String, Object> result) {
		response.setContentType("application/json; charset=utf-8");
		Gson gson = new Gson();
		String json = gson.toJson(result); // result 객체를 json 형식으로 데이터를 변환
		try {
			PrintWriter out = response.getWriter();
			out.print(json); // 호출한 클라이언트 json 데이터를 보낸다
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
