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
			url: '${#pageContext.request.contextPath}' + '/member/idCheck',
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
					
					$("#idCheckMsg").text('사용가능한 아이디 입니다').css('color', '#3bcff2');
					idChecked = true;
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