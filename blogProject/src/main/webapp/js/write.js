$(function() {// jquery 시작
	// 이미지 선택시 미리보기
	const defaultImg = $("#imgPreview").attr('src');
	$("#imgFile").on("change", function() {
		const file = this.files[0];
		if (!file) return;
		const previewUrl = URL.createObjectURL(file);

		$('#imgPreview').attr("src", previewUrl);
		$("#removeImg").val('false'); // 제거눌렀다가 다시 새 파일을 선택하면 제거 요청 취소
	})
	$("#imgRemoveBtn").on("click", function() {
		$("#imgFile").val('');
		$("#imgPreview").attr("src", defaultImg);
		$("#removeImg").val('true'); // modify.jsp에만 있는 hidden, write.jsp엔 없다
	})

	$("#writeForm").on('submit', function(e) {
		const title = $("#title").val().trim();
		const content = $("#content").val().trim();
		if (title === '') {
			alert("제목 입력 하세요");
			e.preventDefault();
			$("#title").focus();
			return;

		}
		if (content == '') {
			alert("내용입력하세요");
			e.preventDefault();
			$("#content").focus();
			return;
		}
	})
})