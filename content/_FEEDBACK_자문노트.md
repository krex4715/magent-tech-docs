# 🔎 자문 피드백 · 의문 / 보강 / 예상질문
---





## Check Point
- [ ] **1. 라벨링 (Q3)** — Friction/Interest는 ground truth 없음(약지도). 라벨 출처 질문에서 터질 수 있음 → 단계적 서사로 방어.
- [ ] **2. 데이터量** — 현재 ~1만 세션 vs 목표 1억(NDA 예정, 미래형). "지금 데이터로 F1 80% 되냐" 대비.
- [ ] **3. "generation" 용어 혼동** — ①템플릿 엔진 ≠ ④LLM 생성. 문서가 둘을 뭉갬.
- [ ] **4. ④ LLM 출력 경계 미정** — 텍스트+파라미터(권장) vs HTML 코드 전체(난이도↑, slide 9 '코드 합성 95%'와 엮임).
- [ ] **5. Element 의미화 cold-start (Q1)** — 신규 UI/신규 고객사 요소 매핑 전략 공백.

---

## B. 의문사항 / Open Questions (외주팀에 확인 필요)
### 모듈 ② HCI Encoder + MLP Head
- [ ] 토큰(이벤트) granularity? raw 이벤트 단위 vs 집계 단위
- [ ] Element ID 의미화(Semantic Element ID) — 미분류/신규 요소 fallback은?
- [ ] x/y 좌표 뷰포트 정규화 여부 (device-agnostic?)
- [ ] causal 보장 — 이벤트 t 피처에 미래정보(세션 총합·전환여부) 누수 없는지
- [ ] 인코더 규모 (layer 수, d_model) — 데이터 대비 과설계 아닌지
- [ ] self-supervised 사전학습 포함 여부 (Masked Event / Next-Event) ← 문서에 없음, 보강 권장

### 모듈 ③ Policy 엔진
- [ ] 규칙(Rule) 개수·유지보수 주체? 버티컬별 규칙 충돌 처리?
- [ ] feature 중요도(SHAP)를 매번 계산 vs 사전 학습된 weight 사용?

### 모듈 ④ QLoRA LLM
- [ ] 출력 스키마 정확히? (카피 문자열 / CTA / 레이아웃 파라미터 / 코드?)
- [ ] Base 모델 확정? (문서 예시 Qwen2.5-7B-4bit) 라이선스·상업이용 OK?
- [ ] Adapter Router 학습형 vs 규칙형? 3개 버티컬에 'MoE'는 과한지
- [ ] 금지표현·브랜드가이드 위반 검수(guardrail) 어디서?

### 데이터/평가
- [ ] gold(사람 라벨) 검증셋 규모·라벨링 주체?
- [ ] 오프라인 지표(F1/AUC) → 온라인 A/B 성과 연결 검증 계획?

---

## C. 고칠사항 / To-Fix (문서 수정 제안)
- [ ] slide 4에 붙은 2-3 아키텍처 이미지 위치 정정 (2-2는 '센서', 2-3은 '해석 모델')
- [ ] "generation" 2종 용어 분리 명시 (① 템플릿 조립 / ④ LLM 생성)
- [ ] ④ LLM 출력 경계를 "텍스트+파라미터"로 못박기 (code synthesis 범위 축소)
- [ ] 라벨링 섹션에 soft-label 방법론 1장 추가 (temporal decay + weak supervision)
- [ ] self-supervised 사전학습 단계 아키텍처에 추가
- [ ] 데이터 로드맵을 "1만→룰/shallow, 축적→Transformer 고도화" 단계로 명확화
- [ ] Element 의미화 cold-start 대응 한 줄 추가

---

## D. 예상 질문 리스트 (Q&A 준비)
> 형식: **Q** / *방어 논지*

- [ ] **Q. 구매의도·불편도 라벨은 어디서 오나? 정답이 없지 않나?**
  *A. Intent/Drop-off는 전환·이탈이라는 관측 outcome에서 temporal-decay soft label로 파생. Friction/Interest는 rage-click·dead-click 등 룰 기반 약지도 + 사람 라벨 gold set으로 검증, 데이터 축적 시 지도학습 전환.*
- [ ] **Q. 1만 건으로 Transformer가 학습되나?**
  *A. self-supervised 사전학습(마스킹)으로 라벨 없이 표현 확보 → 소량 라벨로 head fine-tune. 1차는 룰/shallow 병행, 데이터 축적 후 고도화(단계적 목표).*
- [ ] **Q. F1 80% 근거는? 세계최고는 96%인데?**
  *A. 세계최고는 '식별 고객 이력 포함' 조건. 본 과제는 익명·세션 기반 HCI feature 기준의 현실적 목표. (slide 9 근거 유지)*
- [ ] **Q. 콘텐츠를 AI가 통째로 생성하나?**
  *A. 아니오. ① 결정적 템플릿 엔진이 조립, ④ LLM은 카피/CTA/파라미터만 생성해 템플릿에 주입. 역할 분리.*
- [ ] **Q. Policy가 AI 모델인가?**
  *A. 딥러닝 아님. feature 중요도(SHAP) + IF-THEN 규칙 엔진. 오히려 설명가능성 확보 목적.*
- [ ] **Q. QLoRA를 왜 쓰나? 그냥 파인튜닝과 차이?**
  *A. Base 고정 + 4bit 양자화 + 버티컬별 작은 어댑터만 학습/교체 → 비용·시간 90%↓, 게임/웹툰/커머스 특화를 저비용으로. LoRA/QLoRA 개념*
- [ ] **Q. 경쟁사(뷰저블/버즈빌/Contentsquare) 대비 차별점?**
  *A. 단순 UX 분석이 아니라 '수집→해석→생성→A/B→정책'의 closed-loop 자동화 + 퍼스트파티 행동 데이터 해자.*
- [ ] **Q. 데이터 프라이버시/동의는?** *(방어 논지 채우기)*
- [ ] **Q. 콜드스타트(신규 브랜드/신규 UI) 대응은?** *(방어 논지 채우기)*

---

## E. 모듈별 상세 메모 (채워가기)
- **② HCI Encoder**: → [[2c.(2차년도) Intent-Friction모델-QLoRA⭐]]
- **soft labeling 수식**: temporal decay `label_t = γ^(T−t)`, γ 튜닝 / Snorkel label model (TODO 정리)
- **④ LLM 프롬프트·출력 스키마**: (TODO — 발표자료용 예시 JSON 설계)
