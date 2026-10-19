<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="/include/header.jsp"%>

<main class="join-wrap">
	<h2 class="join-page-title">회원가입</h2>
	<form id="joinForm" class="join-form"
		action="${pageContext.request.contextPath}/member/join" method="post">

		<!-- 아이디 + 중복확인 버튼: 같은 줄에 배치 -->
		<div class="form-row">
			<label for="id">아이디</label>
			<div class="id-check-group">
				<input type="text" id="id" name="id" placeholder="영문/숫자 4~12자"
					class="form-input">
				<button type="button" id="idCheckBtn"
					class="btn btn-outline id-check-btn">중복확인</button>
			</div>
			<p id="idCheckMsg" class="field-msg"></p>
		</div>

		<div class="form-row">
			<label for="pwd">비밀번호</label> <input type="password" id="pwd"
				name="pwd" placeholder="비밀번호를 입력하세요" class="form-input">
		</div>

		<div class="form-row">
			<label for="pwdCheck">비밀번호 확인</label> <input type="password"
				id="pwdCheck" placeholder="비밀번호를 다시 입력하세요" class="form-input">
			<p id="pwdCheckMsg" class="field-msg"></p>
		</div>

		<div class="form-row">
			<label for="nickname">닉네임</label> <input type="text" id="nickname"
				name="nickname" placeholder="닉네임을 입력하세요" class="form-input">
		</div>

		<div class="form-row">
			<label for="email">이메일</label> <input type="email" id="email"
				name="email" placeholder="example@email.com" class="form-input">
		</div>

		<div class="join-btns">
			<a href="${pageContext.request.contextPath}/" class="btn btn-outline">취소</a>
			<button type="submit" class="btn btn-primary">가입하기</button>
		</div>

	</form>
</main>
<script
			src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<%-- <script src="${pageContext.request.contextPath}/js/join.js"></script> --%>
<script>
$(function() {
	let idChecked = false;
	$("#idCheckBtn").on("click", function() {
		const id = $("#id").val().trim();
		if (id === '') {
			alert("아이디를 입력하세요");
			return;
		}
		//실제 연동시 비동기식 방식으로 id존재여부 확인 방법
		$.ajax({
			url: '${pageContext.request.contextPath}/member/idCheck',
			//요청하는 주소
			type: 'get',
			//전송방식
			data: { id: id }, //{"id":"abcd"}
			//전송하는 데이터 {키:값} => 자바스크립트 객체
			dataType: 'json',
			//되돌아 오는 값은 반드시 json 형식으로 받아라
			success: function(result) {
				//서버와 통신이 성공하면 함수를 실행
				if (result.isDuplicate) {
					idChecked = false;
					$("#idCheckMsg").text('이미 사용중인 아이디 입니다').css('color', '#ff3b5c');
				} else {
					idChecked = true;
					$("#idCheckMsg").text('사용가능한 아이디 입니다').css('color', '#3bcff2');
				}
			}, error: function() {
				alert("통신 오류 발생!")
			}
		}) //ajax


	}) //idCheck
	//아이디를 다시 수정하면 중복확인을 다시 받아야 한다
	$("#id").on('input', function() {
		idChecked = false;
		$("#idCheckMsg").text('');
	})
	//비밀번호 확인 일치 검사
	$("#pwdCheck").on('input', function() {
		const pwd = $("#pwd").val();
		const pwdCheck = $(this).val();
		if (pwdCheck === '') {
			$("#pwdCheckMsg").text('');
		} else if (pwd === pwdCheck) {
			$("#pwdCheckMsg")
				.text("비밀번호가 일치 합니다")
				.css('color', '#3b6ff2');
		} else {
			$("#pwdCheckMsg")
				.text("비밀번호가 일치 하지 않습니다")
				.css('color', '#ff3b5c');
		}
	}) //pwdCheck

	//가입하기전 최종 점검
	$("#joinForm").on('submit', function(e) {
		if (!idChecked) {
			alert("아이디 중복확인을 해 주세요");
			e.preventDefault();
			return;
		}
		if ($('#pwd').val() !== $("#pwdCheck").val()) {
			alert("비밀번호가 일치하지 않습니다");
			e.preventDefault();
			return;
		}
	})
}) //end
</script>
<%@ include file="/include/footer.jsp"%>
