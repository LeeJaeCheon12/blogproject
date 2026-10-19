package controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/imgs/*")
public class ImageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Path UPLOAD_DIR = Paths.get("C:/upload").toAbsolutePath().normalize();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		System.out.println("ImageServlet 호출됨 pathInfo = " + request.getPathInfo());
		String pathInfo = request.getPathInfo(); // 예: /UUID_cat.jpg
		if (pathInfo == null || pathInfo.length() <= 1) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String fileName = pathInfo.substring(1);
		Path file = UPLOAD_DIR.resolve(fileName).normalize();
		System.out.println("찾는 파일 = " + file + " / 존재 = " + Files.isRegularFile(file));

		// ../ 로 다른 폴더 접근하는 것 차단 + 파일 존재 확인
		if (!file.startsWith(UPLOAD_DIR) || !Files.isRegularFile(file)) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		String mimeType = getServletContext().getMimeType(file.getFileName().toString());
		response.setContentType(mimeType != null ? mimeType : "application/octet-stream");
		response.setContentLengthLong(Files.size(file));

		Files.copy(file, response.getOutputStream());
	}
}