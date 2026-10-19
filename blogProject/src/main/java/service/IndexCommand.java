package service;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BoardDao;
import model.BoardDto;

public class IndexCommand implements Command {

	@Override
	public boolean doCommand(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		List<BoardDto> poplist = new BoardDao().selectPopular();
		List<BoardDto> latestlist = new BoardDao().selectLatestList();
		request.setAttribute("poplist", poplist);
		request.setAttribute("latestList", latestlist);
		return true;
	}

}
