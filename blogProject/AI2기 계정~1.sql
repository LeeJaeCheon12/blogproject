--blog 프로젝트
create table member (
    id varchar2(20) not null,
    pwd varchar2(200),
    nickname varchar2(30) not null,
    email varchar2(100) not null,
    join_date date default sysdate,
    constraint pk_member primary key (id)
);
select * from member;
-- board 테이블
create table board (
    bno number not null, -- 게시글 번호(기본키,시퀀스이용해서 자동 증가 저장)
    title varchar2(200) not null,
    content clob not null, --clob은 많은 자료를 저장할 때 사용 blob(바이너리 데이터저장)
    writer varchar2(20) not null,
    reg_date date default sysdate, --작성일
    mod_date date, --수정일 수정안했으면 null
    view_cnt number default 0, -- 조회수
    like_cnt number default 0, -- 좋아요 수
    img_path varchar2(300), -- 대표이미지
    constraint pk_board primary key (bno),
    constraint fk_board_writer FOREIGN key (writer) REFERENCES member (id)
);    
select * from board;

--reply
create table reply(
    rno number not null, -- 댓글번호
    bno number not null, -- 어떤 게시글의 댓글인지 (board.bno 참조)
    writer varchar2(20) not null, -- 댓글 작성자 (member.id 참조)
    content varchar2(500) not null, -- 댓글내용
    reg_date date default sysdate, -- 작성일
    CONSTRAINT pk_reply primary key (rno),
    CONSTRAINT fk_reply_board FOREIGN key (bno) references board(bno) on DELETE CASCADE,
    constraint fk_reply_writer foreign key (writer) references member (id)
);
select * from reply;
delete from reply where rno = 1;
-- on delete cascade : 게시글이 삭제되면 그 글에 달린 댓글도 자동으로 같이 삭제한다
-- board_like : (좋아요 - 중복 방지용 매핑 테이블)
CREATE TABLE board_like (
    bno NUMBER NOT NULL,
    member_id VARCHAR2(20) NOT NULL,
    like_date DATE DEFAULT SYSDATE,

    CONSTRAINT pk_board_like
        PRIMARY KEY (bno, member_id),

    CONSTRAINT fk_like_board
        FOREIGN KEY (bno)
        REFERENCES board(bno)
        ON DELETE CASCADE,

    CONSTRAINT fk_like_member
        FOREIGN KEY (member_id)
        REFERENCES member(id)
);
select * from board_like;
DELETE FROM board_like
WHERE member_id = 'java01';
-- 시퀀스 (oracle)에서 자동증가
create sequence seq_board;
create sequence seq_reply;

--샘플데이터 동작 확인용
-- 회원 2명
INSERT INTO MEMBER(ID, PWD, NICKNAME, EMAIL) VALUES('java01', '1234', '홍길동', 'hong@test.com');
INSERT INTO MEMBER(ID, PWD, NICKNAME, EMAIL) VALUES('java02', '1234', '김철수', 'kim@test.com');

-- 게시글 2개 (시퀀스로 번호 자동 생성)
INSERT INTO BOARD(BNO, TITLE, CONTENT, WRITER) VALUES(SEQ_BOARD.NEXTVAL, '첫 번째 글입니다', '안녕하세요, 첫 글이에요.', 'java01');
INSERT INTO BOARD(BNO, TITLE, CONTENT, WRITER) VALUES(SEQ_BOARD.NEXTVAL, '두 번째 글입니다', '내용을 적어봅니다.', 'java02');

-- 댓글 1개
INSERT INTO REPLY(RNO, BNO, WRITER, CONTENT) VALUES(SEQ_REPLY.NEXTVAL, 1, 'java02', '좋은 글이네요!');

-- 좋아요 1개
INSERT INTO BOARD_LIKE(BNO, MEMBER_ID) VALUES(1, 'java02');

COMMIT;