<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/header.jsp"%>
<main class="mypage-wrap">

	<h2 class="mypage-page-title">마이페이지</h2>
	<p class="mypage-sub">${sessionScope.loginMember.nickname}님,환영합니다</p>

	<!-- 탭 메뉴: jQuery로 클릭한 탭만 보이게 전환 -->
	<div class="mypage-tabs">
		<button type="button" class="mypage-tab-btn active" data-tab="myPosts">내
			글</button>
		<button type="button" class="mypage-tab-btn" data-tab="myReplies">내
			댓글</button>
		<button type="button" class="mypage-tab-btn" data-tab="myLikes">좋아요한
			글</button>
	</div>

	<!-- 탭 ① 내 글: 지금까지 만든 카드형 리스트와 같은 구조 -->
	<div id="myPosts" class="mypage-panel active">
		<ul class="mypage-list">
			<c:forEach var="b" items="${myPosts }">
				<li class="mypage-item"><c:choose>
						<c:when test="${not empty b.imgPath }">
							<img src="${pageContext.request.contextPath}/imgs/${b.imgPath}"
								alt="게시글 썸네일" class="mypage-thumb">
						</c:when>
						<c:otherwise>
							<img
								src="${pageContext.request.contextPath}/image/defalut-thumb.jpg"
								alt="게시글 썸네일" class="mypage-thumb">
						</c:otherwise>
					</c:choose>
					<div class="mypage-item-info">
						<p class="mypage-item-title">${b.title }</p>
						<p class="mypage-item-meta">${b.regDate }·조회${b.viewCnt }·좋아요
							${b.likeCnt }</p>
					</div></li>
			</c:forEach>

		</ul>
	</div>

	<!-- 탭 ② 내 댓글: 이미지 없이 텍스트 위주 리스트 -->
	<div id="myReplies" class="mypage-panel">
		<ul class="mypage-list">
			<c:forEach var="r" items="${myReplies}">
				<li class="mypage-reply-item">
					<p class="mypage-reply-content">${r.content }</p>
					<p class="mypage-item-meta">원글: ${r.boardTitle} · ${r.regDate }</p>
				</li>
			</c:forEach>

		</ul>
	</div>

	<!-- 탭 ③ 좋아요한 글: 내 글과 같은 카드 구조 재사용 -->
	<div id="myLikes" class="mypage-panel">
		<ul class="mypage-list">
			<c:forEach var="b" items="${myLikes }">
				<li class="mypage-item"><img
					src="${pageContext.request.contextPath}/imgs/${b.imgPath}"
					alt="게시글 썸네일" class="mypage-thumb">
					<div class="mypage-item-info">
						<p class="mypage-item-title">${b.title }</p>
						<p class="mypage-item-meta">작성자 ${b.writerNickname }· 좋아요
							${b.likeCnt }</p>
					</div></li>
			</c:forEach>
		</ul>
	</div>

</main>
<script src="${pageContext.request.contextPath}/js/mypage.js"></script>

<%@ include file="/include/footer.jsp"%>