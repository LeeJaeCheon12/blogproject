package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBUtil;

public class MemberDao {

//	public boolean idCheck(String id) {
//		Connection conn = null;
//		PreparedStatement pstmt = null;
//		ResultSet rs = null;
//		String sql = "select id from member id=?";
//		
//		boolean isDupicate = false;
//		try {
//			conn=DBUtil.getInstance();
//			pstmt=conn.prepareStatement(sql);
//			pstmt.setString(1, id);
//			rs=pstmt.executeQuery(sql);
//			if(rs.next()) {
//				return true;
//			}
//			
//		}catch(Exception e) {
//			e.printStackTrace();
//		}
//		return isDupicate;
//	}
	public boolean idCheck(String id) {
		String sql = "select id from member where id=?";
		boolean isDuplicate = false;
		try (Connection conn = DBUtil.getInstance(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setString(1, id);
			try (ResultSet rs = pstmt.executeQuery()) {
				isDuplicate = rs.next();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return isDuplicate;

	}

	public void memberinsert(MemberDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		String sql = "INSERT INTO MEMBER(ID, PWD, NICKNAME, EMAIL) VALUES(?, ?, ?, ?)";

		try {
			conn = DBUtil.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPwd());
			pstmt.setString(3, dto.getNickname());
			pstmt.setString(4, dto.getEmail());
			pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	public MemberDto login(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		String sql = "select id,pwd,nickname,email,to_char(join_date, 'YYYY-MM-DD') as join_date from member where id=?";

		MemberDto dto = null;

		try {
			conn = DBUtil.getInstance();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				dto = new MemberDto();
				dto.setId(rs.getString("id"));
				dto.setEmail(rs.getString("email"));
				dto.setJoin_date(rs.getString("join_date"));
				dto.setNickname(rs.getString("nickname"));
				dto.setPwd(rs.getString("pwd"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return dto;
	}

}
