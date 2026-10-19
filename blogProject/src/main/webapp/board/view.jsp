<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!-- header.jsp -->
<%@ include file="/include/header.jsp"%>


<main class="view-wrap">
	<div class="view-header">
		<h2 class="view-title">${view.title}</h2>
		<p class="view-meta">작성자 ${view.writerNickname} | ${view.regDate}
			| 조회 ${view.viewCnt}</p>
	</div>
	<div class="view-image">
		<img src="/imgs/${view.imgPath}" alt="" class="view-thumb">
	</div>
	<div class="view-content">${view.content}</div>
	<div class="view-actions">
		<button type="button" id="likeBtn"
			class="btn btn-outline like-btn ${liked ? 'liked' :''}">
			♥ 좋아요<span id="likeCount">${view.likeCnt}</span>
		</button>
		<div class="view-actions-right">
			<a
				href="${pageContext.request.contextPath}/blog/update?bno=${view.bno}"
				class="btn btn-outline">수정</a> <a
				href="${pageContext.request.contextPath}/blog/delete?bno=${view.bno}"
				class="btn btn-outline" onclick="return confirm('삭제하시겠습니까?')">삭제</a>
			<a href="${pageContext.request.contextPath}/blog/list"
				class="btn btn-primary">목록</a>
		</div>
	</div>
	<!-- 댓글 영역 -->
	<div class="reply-section">
		<h3 class="reply-title">
			댓글<span id="replyCount">${fn:length(replylist)}</span>
		</h3>
		<ul class="reply-list" id="replylist">
			<c:forEach var="r" items="${replylist}">
				<li class="reply-item" data-rno="${r.rno}">
					<div class="reply-info">
						<span class="reply-writer">${r.nickName}</span> <span
							class="reply-date">${r.regDate}</span>
					</div>
					<p class="reply-content">${r.content}</p>
					<div class="reply-bnts">
						<button type="button" class="reply-edit-btn">수정</button>
						<button type="button" class="reply-delete-btn">삭제</button>

					</div>
				</li>
			</c:forEach>
		</ul>
	</div>

	<div class="reply-form">
		<input type="text" id="replyContent" placeholder="댓글을 입력하세요"
			class="reply-input">
		<button type="button" id="replySubmitbtn" class="btn btn-primary">등록</button>
	</div>
	<!-- footer.jsp -->


	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"></script>

	<script>
			//jquery 좋아요
			$("#likeBtn").on("click", function() {
			const bno = "${view.bno}";
				$.ajax({
					url:"${pageContext.request.contextPath}/blog/like",
					type:'post',
					data:{bno:bno},
					dataType:'json',
					success:function(result){
						if(!result.success){
							alert(result.message);
							return;
						}
						$("#likeCount").text(result.likeCount);
						$("#likeBtn").toggleClass("liked", result.liked);
					},error:function(){
						alert("통신오류");
					}
				})
			});
			//---댓글 등록---
			$("#replySubmitbtn").on("click",function(){
				const content = $("#replyContent").val().trim(); // trim 공백제거
				if(content == ""){
					alert("댓글 내용을 입력하세요");
					return;
				}
				$.ajax({
					url: "${pageContext.request.contextPath}/reply/write",
					type: 'post',
					data: {bno:${view.bno}, content:content},
					dataType: 'json',
					success:function(result){
						if(!result.success){
							alert(result.message || '댓글등록 실패');
							return
						}
						//
						//`` O '' X
						const newItem=`
							<li class="reply-item" data-rno="\${result.rno}">
							<div class="reply-info">
								<span class="reply-writer">\${result.writeNickname}</span> <span class="reply-date">방금 전</span>
							</div>
							<p class="reply-content">\${result.content}</p>
							<div class="reply-bnts">
								<button type="button" class="reply-edit-btn">수정</button>
								<button type="button" class="reply-delete-btn">삭제</button>

							</div>
						</li>
						`;
						
						$("#replylist").append(newItem);
						$("#replyContent").val('');
					},error:function(){
						alert("댓글 등록 중 오류가 발생");
					}
				})
				
				
				/* 실제연동 시 비동기식으로 데이터 처리 할 거다
				$.ajax({
					
				});
				*/
			});
			
			// ---- 댓글 삭제 ----
			$("#replylist").on("click", '.reply-delete-btn', function(){
				if(confirm('댓글을 삭제?')){
					
					// 실제 연동시 rno값을 data-rno에서 꺼내서 비동기식으로 처리
					const $item = $(this).closest('.reply-item'); // 클릭한 li 요소			
					const rno = $item.data('rno');	//li 태그의 data-rno 속성 값
					$.ajax({
						url:"${pageContext.request.contextPath}/reply/delete",
						type:'post',
						data:{rno : rno},
						dataType:'json',
						success:function(result){
							if(result.success){
								$item.remove();
								
							}else{
								alert(result.message);
							}
						},error:function(){
							alert("통신오류");
						}
					})
				}
			});
			// ---- 댓글 수정 ----
$("#replylist").on("click", '.reply-edit-btn', function(){
    const $item = $(this).closest('.reply-item');
    $('#modalRno').val($item.data('rno'));
    $('#modalContent').val($item.find('.reply-content').text());

    bootstrap.Modal.getOrCreateInstance(document.getElementById('replyModal')).show();
});

$('#replyModal').on('shown.bs.modal', function(){
    $('#modalContent').focus();
});

$(document).on('click', '#modalSaveBtn', function(){
	const rno = $('#modalRno').val();
	const newContent = $('#modalContent').val().trim();
	if(newContent == ''){
		alert('댓글 내용을 입력하세요');
		return;
	}
	$.ajax({
		url: '${pageContext.request.contextPath}/reply/modify',
		type:'post',
		data:{rno:rno,content:newContent},
		dataType:'json',
		success:function(result){
			if(result.success){
				$('#replylist .reply-item[data-rno="'+rno+'"]')
				.find(".reply-content").text(result.content);
				 bootstrap.Modal.getInstance(document.getElementById('replyModal')).hide();
			}else{
				alert(result.message);
			}
		},error:function(){
			alert("통신오류");
		}
	});
});
			//자바스크립트
			/* document
					.getElementById("likeBtn")
					.addEventListener(
							"click",
							function() {
								//likebtn 아이디이름이 붙은 태그를 클릭했을때
								let likebtn = this;
								// 좋아요 버튼
								likebtn.classList.toggle("liked");
								//liked 클래스가 있으면 제거하고, 없으면 추가한다
								let count = parseInt((document
										.getElementById("likeCount").textContent));
								if (likeBtn.classList.contains("liked")) {
									document.getElementById("likeCount").textContent = count + 1;
								} else{
									document.getElementById("likeCount").textContent = count - 1;
								}
							}) */
							
							
						
							
		</script>

</main>
<!-- Modal -->
<div class="modal fade" id="replyModal" tabindex="-1"
	aria-labelledby="exampleModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<h1 class="modal-title fs-5" id="exampleModalLabel">댓글 수정</h1>
				<button type="button" class="btn-close" data-bs-dismiss="modal"
					aria-label="Close"></button>
			</div>
			<div class="modal-body">
				<input type="hidden" id="modalRno">
				<textarea id="modalContent" class="form-control" row="4"></textarea>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary"
					data-bs-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" id="modalSaveBtn">Save
					changes</button>
			</div>
		</div>
	</div>
</div>





<%@include file="/include/footer.jsp"%>