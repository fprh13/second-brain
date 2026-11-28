# 출처와 스냅샷 명세

생성 기준일은 2026-11-25(Asia/Seoul)입니다. 프론트 Git에 추적된 현재 파일을 선별해 바이트 그대로 복사했고 각 파일이 HEAD blob과 동일함을 확인했습니다. 환경변수 파일이나 비밀값은 읽거나 복사하지 않았습니다.

|구분|원본 위치·기준|
|---|---|
|프론트 저장소|`/Users/yeongmujo/Desktop/Repository/dokidoki-frontend`|
|프론트 브랜치/HEAD|`develop` / `aa1c879b7715060840a0a0c3e46eeeb4ebc762de`|
|작업 시작 상태|프론트·백엔드 모두 `git status --short` 출력 없음|
|백엔드 저장소|`/Users/yeongmujo/Desktop/Repository/dokidoki-backend`|
|백엔드 시작 브랜치/HEAD|`develop` / `3659b35aefcd4eef347ddbe04f5411ecd193638a`|
|산출물 브랜치|`docs/backend-handoff-package`|
|초기 OpenAPI|최초 커밋 `6092e11`의 docs/openapi.draft.json과 현재가 바이트 동일; 해당 경로 git log 1건|
|기존 전달 초안|백엔드 docs/references/fronted-api.draft.json과 현재 프론트 초안이 바이트 동일|

프론트 최근 커밋은 아래와 같습니다. 최근 배포 준비 문서도 실제 서버 연결이 미완료임을 명시합니다.

```text
aa1c879 merge: develop <- perf/production-readiness
238bb1c docs: 성능 측정 결과와 프로덕션 배포 절차 정리
3de9ccb chore(quality): 접근성 개선과 운영 빌드 검증 자동화
1ca6a47 perf(frontend): 라우트 지연 로딩과 폰트 서브셋 적용
b2495e4 merge: develop <- test/e2e-regression
```

## 스냅샷 선택 기준

요청한 AGENTS·개요·화면·아키텍처·API/MSW·초안·작업계획·미확정 문서와 이후 기능별 구현/운영 문서를 보존했습니다. 핵심 HTTP·DTO·모델·Query·인증·폼·MSW·fixture·HTTP 테스트·페이지 소스도 보존했습니다. 원본 상대 디렉터리를 유지하여 각 출처를 쉽게 찾을 수 있습니다.

`node_modules`, dist/build, Git 내부 파일, 환경 파일, 이미지·폰트·디자인 원본은 제외했습니다. package.json은 버전/검증 명령 참고용이며 실행 환경 복제용 lockfile/의존성 전체는 제공하지 않습니다. snapshot 내 공개 mock-password/mock-csrf 상수는 테스트 fixture로 원문을 보존한 것이며 운영 자격이 아닙니다.

스냅샷 소스의 import는 일부 UI/CSS·설정 파일이 제외되어 독립 빌드되지 않습니다. 원본 문서의 과거 단계 설명·상대 링크도 그대로 보존했습니다. 포함하지 않은 디자인·이미지·스크립트 등에 대한 링크는 원본 저장소에서 확인해야 하며 패키지 검증 시 별도 누락 목록으로 기록합니다. 이 링크를 해결하려고 원본 문구를 변경하지 않습니다. 새 분석 문서는 패키지 내부 링크로 검증합니다.

## 파일별 원본 → 스냅샷 → SHA-256

아래 원본은 모두 위 프론트 루트 기준입니다. 기계 판독 목록은 [snapshot-manifest.json](references/snapshot-manifest.json)입니다. hash는 내용 바이트의 SHA-256입니다.

|원본 상대 경로|패키지 스냅샷|SHA-256|
|---|---|---|
|`AGENTS.md`|[references/frontend/AGENTS.md](references/frontend/AGENTS.md)|`3f57bd4e101825cd7668705a556b0888bdafa591bee31e9fcddfa7bd9d68ea52`|
|`README.md`|[references/frontend/README.md](references/frontend/README.md)|`f84df87635f4db4076fc6c55e15c4063bcd4a35ef87644fb23ab85cb1953edac`|
|`docs/01-screens-and-flows.md`|[references/frontend/docs/01-screens-and-flows.md](references/frontend/docs/01-screens-and-flows.md)|`166ef73bb7fcb2ccc8e1585eb56410527b16ed69dbc5c023380b73420d4a91fe`|
|`docs/02-architecture.md`|[references/frontend/docs/02-architecture.md](references/frontend/docs/02-architecture.md)|`0add0353f2161722b8e3438d6c79ca97af783639ff9a6905c83563deddfc674c`|
|`docs/03-api-and-msw.md`|[references/frontend/docs/03-api-and-msw.md](references/frontend/docs/03-api-and-msw.md)|`8aea9a8c3bb7221bd01f66bb80fa4589427dedd1e6cffba6874f5d0319bd44a2`|
|`docs/04-delivery-plan.md`|[references/frontend/docs/04-delivery-plan.md](references/frontend/docs/04-delivery-plan.md)|`493de91f40cb53fe93604da599854598030bbe561c91d74f73c9fb0bcf282bae`|
|`docs/05-open-questions.md`|[references/frontend/docs/05-open-questions.md](references/frontend/docs/05-open-questions.md)|`86d308b3226e556599693c19578109349e42c1a1e0a4034dc963abb38963d92d`|
|`docs/06-validation.md`|[references/frontend/docs/06-validation.md](references/frontend/docs/06-validation.md)|`35cf279b77c5bd17f6f9a8d6e754a106a70bd850e2ce4c0f43ab70ddb4442a23`|
|`docs/07-style-foundation.md`|[references/frontend/docs/07-style-foundation.md](references/frontend/docs/07-style-foundation.md)|`27bb070fe85630e8822088c8beaf59f808a50531754dfe0262bb896350026279`|
|`docs/08-shared-ui.md`|[references/frontend/docs/08-shared-ui.md](references/frontend/docs/08-shared-ui.md)|`f47fd7da3dc6ee6f551b402eb31d78e2a70bce092c73d03f5b80a7c60c967635`|
|`docs/09-api-foundation.md`|[references/frontend/docs/09-api-foundation.md](references/frontend/docs/09-api-foundation.md)|`ccd06652c741286315cccc79c19f6b066bb2b759097ab6f8308362f78af4ad18`|
|`docs/10-auth.md`|[references/frontend/docs/10-auth.md](references/frontend/docs/10-auth.md)|`ccd9d721858d6affa78ca85eb99a3b5ebc4f6ff9a1251c5574947e166c1e6415`|
|`docs/11-discovery.md`|[references/frontend/docs/11-discovery.md](references/frontend/docs/11-discovery.md)|`ac15329f7ba70142aadd7466061ac161382b02e27a234b8e30da5a5a711c0cd4`|
|`docs/12-watch-records.md`|[references/frontend/docs/12-watch-records.md](references/frontend/docs/12-watch-records.md)|`15d4406892c5ca83b6281c4dd5682810406163221fc5ea8672450db0adb00d1b`|
|`docs/13-profile.md`|[references/frontend/docs/13-profile.md](references/frontend/docs/13-profile.md)|`185309a1bec6d4ec759505a4f6c3c5ce001aea62534573958c1ebb9e1f9fcc33`|
|`docs/14-visual-qa.md`|[references/frontend/docs/14-visual-qa.md](references/frontend/docs/14-visual-qa.md)|`939346321400bbf155789337fb8b523c3074bbe1d45c90f529a456799e973b77`|
|`docs/15-e2e-regression.md`|[references/frontend/docs/15-e2e-regression.md](references/frontend/docs/15-e2e-regression.md)|`494d4da50c18ec5f8ce6b199bfc674822854fe86e751ae7d6d329d1cb5909b4a`|
|`docs/16-performance-accessibility.md`|[references/frontend/docs/16-performance-accessibility.md](references/frontend/docs/16-performance-accessibility.md)|`d76907893061f84d818ec3216e62cf83515a4a2e20d69f110ab3a58927c83ca1`|
|`docs/17-production-deployment.md`|[references/frontend/docs/17-production-deployment.md](references/frontend/docs/17-production-deployment.md)|`edd3080ebbfea39f081178a82cc27d51b677d8a7e84a5632977ce503963104e3`|
|`docs/README.md`|[references/frontend/docs/README.md](references/frontend/docs/README.md)|`92be7c58ba36864e899170300433919de4314fd73d660d3879c4892aff252d07`|
|`docs/openapi.draft.json`|[references/frontend/docs/openapi.draft.json](references/frontend/docs/openapi.draft.json)|`110f277bc28613466b8845adbab16474db71bb16c21c3f200f588715b2846871`|
|`package.json`|[references/frontend/package.json](references/frontend/package.json)|`71df9dd8a65696de9f931a71d88a1752659af8e23e395faf583cdec7c0e55c31`|
|`scripts/api-types.mjs`|[references/frontend/scripts/api-types.mjs](references/frontend/scripts/api-types.mjs)|`05b67d9e234b3351518ec2e5d6aec8f2ef7c7500b5e0ae0ec110e26b245ade53`|
|`src/app/router/AuthLayout.tsx`|[references/frontend/src/app/router/AuthLayout.tsx](references/frontend/src/app/router/AuthLayout.tsx)|`aecf997f5c05107539237bae8f17ce79e8b11eca14bae3355535ec7b4d73353d`|
|`src/features/anime/api.ts`|[references/frontend/src/features/anime/api.ts](references/frontend/src/features/anime/api.ts)|`b1d6166024ca5ae7e6de8f447f051b88329acaaa5a75c98f2e0d9a956e64c8bf`|
|`src/features/anime/model.ts`|[references/frontend/src/features/anime/model.ts](references/frontend/src/features/anime/model.ts)|`c85025b4aa1a6ccad8c0a17c05e0dcedb44474ebbd82319b672a148fa2631011`|
|`src/features/anime/queries.ts`|[references/frontend/src/features/anime/queries.ts](references/frontend/src/features/anime/queries.ts)|`a804d69e9874638cf68e6d57a5d9331b9ef68cc7806da8bdc250bd216063c1bb`|
|`src/features/auth/api.ts`|[references/frontend/src/features/auth/api.ts](references/frontend/src/features/auth/api.ts)|`16cd75eeab01da60f1dc8997f874bda0705849125a8c71d3c3f8cf0c68cc0798`|
|`src/features/auth/model.ts`|[references/frontend/src/features/auth/model.ts](references/frontend/src/features/auth/model.ts)|`445a2339b54d5326725a1f495012c525cdbc6aa018eafc9cf4c23e50060ce690`|
|`src/features/auth/navigation.ts`|[references/frontend/src/features/auth/navigation.ts](references/frontend/src/features/auth/navigation.ts)|`b4425e90b22d1e759f9ed7cc3579b50f58a7601869225101d286569daab571c8`|
|`src/features/auth/queries.ts`|[references/frontend/src/features/auth/queries.ts](references/frontend/src/features/auth/queries.ts)|`84abedfd6850efefa23a526dad4fc75c99629b1635c215e00006f09cb4228df0`|
|`src/features/auth/useAuthForm.ts`|[references/frontend/src/features/auth/useAuthForm.ts](references/frontend/src/features/auth/useAuthForm.ts)|`87b2c358c5adc542f52cd1e059e837518fbe9a3ed84be06996649d6ab2dd4863`|
|`src/features/auth/validation.ts`|[references/frontend/src/features/auth/validation.ts](references/frontend/src/features/auth/validation.ts)|`54a8525f2f7288639a99bd1dba7991f523d427167a3a959056b89176278fe132`|
|`src/features/profile/ProfileEditForm.tsx`|[references/frontend/src/features/profile/ProfileEditForm.tsx](references/frontend/src/features/profile/ProfileEditForm.tsx)|`c0cba4619001dadefba736574c9da74836978ac1ff55181e97d552c2f0dfd32f`|
|`src/features/profile/api.ts`|[references/frontend/src/features/profile/api.ts](references/frontend/src/features/profile/api.ts)|`7b0137a83aa465f8cf9a5cca4a615ba312afd44b9eb7239c9fc5b7471d42bb54`|
|`src/features/profile/model.ts`|[references/frontend/src/features/profile/model.ts](references/frontend/src/features/profile/model.ts)|`4ed4fcd4c242e6f0428d594e21bf6ccbb78e688e01bbed9b9eb65bf311037906`|
|`src/features/profile/queries.ts`|[references/frontend/src/features/profile/queries.ts](references/frontend/src/features/profile/queries.ts)|`1d9e059a6745bf93eb9bec2960a0d4df91e515cb4e0b3bcf9091aaeb6eea6633`|
|`src/features/recommendations/api.ts`|[references/frontend/src/features/recommendations/api.ts](references/frontend/src/features/recommendations/api.ts)|`0c94b0238e6037dbe17c14d79194ef4dea2481fdcf85608e4d166bc485947656`|
|`src/features/recommendations/queries.ts`|[references/frontend/src/features/recommendations/queries.ts](references/frontend/src/features/recommendations/queries.ts)|`a69d2f69640ef08863ea8147154a0873fdd476228201f668d2489296f327c607`|
|`src/features/recommendations/useRecommendations.ts`|[references/frontend/src/features/recommendations/useRecommendations.ts](references/frontend/src/features/recommendations/useRecommendations.ts)|`ab6bae96a73414c799b566d322309652ecf8dd2b9d10ba3662b062b2a92d8dac`|
|`src/features/records/RecordForm.tsx`|[references/frontend/src/features/records/RecordForm.tsx](references/frontend/src/features/records/RecordForm.tsx)|`c086f58e666915c672af8accffbd0b03a660659ad40e39786319532d1f7bd37d`|
|`src/features/records/api.ts`|[references/frontend/src/features/records/api.ts](references/frontend/src/features/records/api.ts)|`042569dcba542937343bebdaa86bcabe72783a45719575b0b22fefc08154fa17`|
|`src/features/records/model.ts`|[references/frontend/src/features/records/model.ts](references/frontend/src/features/records/model.ts)|`9d8a7867fadf8564649e48ecd449d2aa6aead2c21931a2f9a25a8d1fba259bda`|
|`src/features/records/queries.ts`|[references/frontend/src/features/records/queries.ts](references/frontend/src/features/records/queries.ts)|`6fee9bedc95f11093cc1a4a31f4a46eb6fb7326ab0f2a2f43866f3b06e51cde2`|
|`src/main.tsx`|[references/frontend/src/main.tsx](references/frontend/src/main.tsx)|`7d10272eb00271c5ba6ea6f3e18b1b5148a1c01337e43e48f0f83c8e14dd03c6`|
|`src/mocks/browser.ts`|[references/frontend/src/mocks/browser.ts](references/frontend/src/mocks/browser.ts)|`ae54553ad4072abbaa0ad5dd812d6ea63851adadb0f373f71b6c66f2377b860f`|
|`src/mocks/contract.ts`|[references/frontend/src/mocks/contract.ts](references/frontend/src/mocks/contract.ts)|`9c087af8d93dab779a6b64f6f646070ab9e7be6f46756b6079ddb5b80bed3bb4`|
|`src/mocks/db.ts`|[references/frontend/src/mocks/db.ts](references/frontend/src/mocks/db.ts)|`b5ed60bdc61fe19c3a4df34e33e9de61a2c2dd54c111e7515059496f03cb0cc9`|
|`src/mocks/fixtures/catalog.ts`|[references/frontend/src/mocks/fixtures/catalog.ts](references/frontend/src/mocks/fixtures/catalog.ts)|`df86086c7c15d66cc3ce6e4409a81579974b6f75023243cedeb3de78d1d27490`|
|`src/mocks/fixtures/recommendations.ts`|[references/frontend/src/mocks/fixtures/recommendations.ts](references/frontend/src/mocks/fixtures/recommendations.ts)|`199ef096f4d5c8c18827f7237006c5a6ede008066bfcddd072846ecf8aadab61`|
|`src/mocks/handlers/anime.ts`|[references/frontend/src/mocks/handlers/anime.ts](references/frontend/src/mocks/handlers/anime.ts)|`503ab6500bfada09c66ec4b9d765aa5e3e9560ae11f28be233f0633cf52ea2e6`|
|`src/mocks/handlers/auth.ts`|[references/frontend/src/mocks/handlers/auth.ts](references/frontend/src/mocks/handlers/auth.ts)|`fe69eb6a20693368768745f923699c66a5bb6172af67c4b39b9359e96ee22401`|
|`src/mocks/handlers/index.ts`|[references/frontend/src/mocks/handlers/index.ts](references/frontend/src/mocks/handlers/index.ts)|`3f518ab7e7680599e98cb8306d0788b854cbddecaf22c4dbc6670ebe0aceec18`|
|`src/mocks/handlers/recommendations.ts`|[references/frontend/src/mocks/handlers/recommendations.ts](references/frontend/src/mocks/handlers/recommendations.ts)|`79c5e720dfb66cb5e71a1032522df2571bc4ca90fca6e6ac38e602fecb6e9f1b`|
|`src/mocks/handlers/records.ts`|[references/frontend/src/mocks/handlers/records.ts](references/frontend/src/mocks/handlers/records.ts)|`d34c13a4c5c6ecdc8f13c3d346425b488549156878f23e529adab0bd3f8a3b02`|
|`src/mocks/handlers/support.ts`|[references/frontend/src/mocks/handlers/support.ts](references/frontend/src/mocks/handlers/support.ts)|`c29bb46abd5afc8d07ca6a93100c6d4a7406cddca419e32b43a3064c9727e96f`|
|`src/mocks/scenarios.ts`|[references/frontend/src/mocks/scenarios.ts](references/frontend/src/mocks/scenarios.ts)|`84055faf9a2a87c1c2da2ba75be566a056524bb225f154d355e59c10fe6ba9f8`|
|`src/mocks/server.ts`|[references/frontend/src/mocks/server.ts](references/frontend/src/mocks/server.ts)|`3795d44c921e70ae947955028dc36a1dfd975e9e3843b5733e0c7f0a74b82983`|
|`src/pages/AnimeDetailPage.tsx`|[references/frontend/src/pages/AnimeDetailPage.tsx](references/frontend/src/pages/AnimeDetailPage.tsx)|`624487dffbcf5803150114b2e3bc57575edabe942871e58e3d908d19491ef520`|
|`src/pages/HistoryPage.tsx`|[references/frontend/src/pages/HistoryPage.tsx](references/frontend/src/pages/HistoryPage.tsx)|`420946ee56adc55d3685bf76132608ac6c1ccf31a30fb11ee47b1d91e6517062`|
|`src/pages/HomePage.tsx`|[references/frontend/src/pages/HomePage.tsx](references/frontend/src/pages/HomePage.tsx)|`0d01700c88afa33bd96f300678a1042ed4543204f93897422396905eb22c98fc`|
|`src/pages/LoginPage.tsx`|[references/frontend/src/pages/LoginPage.tsx](references/frontend/src/pages/LoginPage.tsx)|`2b6bbf221d745fb175641947398b8bc21c662d40ad2fd50ddd7cce7df36c97b2`|
|`src/pages/MyPage.tsx`|[references/frontend/src/pages/MyPage.tsx](references/frontend/src/pages/MyPage.tsx)|`83494ce1ac2a548b203dfcc195193f1bad955187db6ec12abf8bf35cebc52f53`|
|`src/pages/NotFoundPage.tsx`|[references/frontend/src/pages/NotFoundPage.tsx](references/frontend/src/pages/NotFoundPage.tsx)|`9173c7e057d9892bab2131f6c8da3833595f5d163a6f9f75a244d9b13e472256`|
|`src/pages/ProfileDonePage.tsx`|[references/frontend/src/pages/ProfileDonePage.tsx](references/frontend/src/pages/ProfileDonePage.tsx)|`a3cdf7340b9c25613049e43fa68fbc6f232ae815274170bc19088bfdc738bbea`|
|`src/pages/ProfilePage.tsx`|[references/frontend/src/pages/ProfilePage.tsx](references/frontend/src/pages/ProfilePage.tsx)|`5b624bc54305e9c5e2f6dca349b3ee5e6a7d66b83560a6c405638a644938d372`|
|`src/pages/RecommendationsPage.tsx`|[references/frontend/src/pages/RecommendationsPage.tsx](references/frontend/src/pages/RecommendationsPage.tsx)|`6b4baca430df604b778ae53618d76fd8806d9c5fefae0a702be3c6311d3afb81`|
|`src/pages/RecordDonePage.tsx`|[references/frontend/src/pages/RecordDonePage.tsx](references/frontend/src/pages/RecordDonePage.tsx)|`a6a835cca8bf1f272b0519567e883b213b19c71e5abc45116e92f3b8e07922d5`|
|`src/pages/RecordEditPage.tsx`|[references/frontend/src/pages/RecordEditPage.tsx](references/frontend/src/pages/RecordEditPage.tsx)|`7e4587797138ebd368a09b8a5708889aeaf746bd7a7fce06ae4f36bdfc8f9c00`|
|`src/pages/RecordPage.tsx`|[references/frontend/src/pages/RecordPage.tsx](references/frontend/src/pages/RecordPage.tsx)|`5a78f33cc37d029afb344e5a44282708cc0f03a0ce21f36b7398b1cc6a8ae7f4`|
|`src/pages/RoutePendingPage.tsx`|[references/frontend/src/pages/RoutePendingPage.tsx](references/frontend/src/pages/RoutePendingPage.tsx)|`c3276c9f1ce42bb5936b05707f80023528a152268e37464621dafafaed7deec0`|
|`src/pages/SearchPage.tsx`|[references/frontend/src/pages/SearchPage.tsx](references/frontend/src/pages/SearchPage.tsx)|`79702075d964c6d658a2e952e0027e031044bc27de0a9aa691de1d8391aad19f`|
|`src/pages/SignupDonePage.tsx`|[references/frontend/src/pages/SignupDonePage.tsx](references/frontend/src/pages/SignupDonePage.tsx)|`c41e8e9061404253b4524418cd065ac3fa6b3b90e12e39fedfd5aaff2af71a53`|
|`src/pages/SignupPage.tsx`|[references/frontend/src/pages/SignupPage.tsx](references/frontend/src/pages/SignupPage.tsx)|`97a0e1520f9e47a80ab822d59130f481724ede6a9043883a0d841ee24d60ef7b`|
|`src/shared/api/client.ts`|[references/frontend/src/shared/api/client.ts](references/frontend/src/shared/api/client.ts)|`266d733510c78fc568a336e71fd132f7154619e0b1a935abe6f06f3bcd9b3a02`|
|`src/shared/api/config.ts`|[references/frontend/src/shared/api/config.ts](references/frontend/src/shared/api/config.ts)|`20933c3c4e005553678ad89a57301c1e27a18563d7d1bdd48a461e989e44fba8`|
|`src/shared/api/draftSession.ts`|[references/frontend/src/shared/api/draftSession.ts](references/frontend/src/shared/api/draftSession.ts)|`6151edcf7f64ab0d5815f883f0e48f815778b3a1e737065238d9a115689a6592`|
|`src/shared/api/dto.ts`|[references/frontend/src/shared/api/dto.ts](references/frontend/src/shared/api/dto.ts)|`9e0878e32fe1615d891442230c5edda3f6b245eb8fc9fa25a760e0acca5da4ad`|
|`src/shared/api/error.ts`|[references/frontend/src/shared/api/error.ts](references/frontend/src/shared/api/error.ts)|`8679491226b39e4ab6c178b600f6aa68fc0282d7c578a6b8a7690e4d4fa17432`|
|`src/shared/api/generated/schema.d.ts`|[references/frontend/src/shared/api/generated/schema.d.ts](references/frontend/src/shared/api/generated/schema.d.ts)|`e614ffcd64c1f6d4991a6e9c7306f013bee75483e9619ba028a7119ea51c2358`|
|`src/shared/api/queryClient.ts`|[references/frontend/src/shared/api/queryClient.ts](references/frontend/src/shared/api/queryClient.ts)|`8b73ff296abd2192b3de90d4b15b0359c425f586e095b0a617f8d79234c27160`|
|`src/shared/routing/UrlSearchInput.tsx`|[references/frontend/src/shared/routing/UrlSearchInput.tsx](references/frontend/src/shared/routing/UrlSearchInput.tsx)|`3c8304909a71d4f8dd255f49ba0566812c520f48123d1e93137f75aac3d1ba32`|
|`src/shared/routing/paths.ts`|[references/frontend/src/shared/routing/paths.ts](references/frontend/src/shared/routing/paths.ts)|`8fb7add884c7664cf709bd648653cb39c580fc57b24db2793d43fa3625eb8728`|
|`src/test/api.test.ts`|[references/frontend/src/test/api.test.ts](references/frontend/src/test/api.test.ts)|`4bd7a0429395d3977723587b9fdb7a8356ace9f687611a11ce57341fee5b5b5a`|
|`src/test/auth.test.ts`|[references/frontend/src/test/auth.test.ts](references/frontend/src/test/auth.test.ts)|`5fbdfdba35c432aec917e8283d770ba42ce5f3a03b8bd8c1a4d684ba19c6c788`|
|`src/test/discovery.test.ts`|[references/frontend/src/test/discovery.test.ts](references/frontend/src/test/discovery.test.ts)|`860cc4d005d2aa32b8e307bc476b6df2f0d0f0ee93b396268000b345355f413e`|
|`src/test/profile.test.ts`|[references/frontend/src/test/profile.test.ts](references/frontend/src/test/profile.test.ts)|`79e7d574f7aeac59ab8da2df13aed3e42687e7f216c9ffcbd321ae0238837b30`|
|`src/test/query.test.ts`|[references/frontend/src/test/query.test.ts](references/frontend/src/test/query.test.ts)|`08226da08dc11a64ea697b1838e0f27874530bc537fd0b0673bfba3b6425fb75`|
|`src/test/records.test.ts`|[references/frontend/src/test/records.test.ts](references/frontend/src/test/records.test.ts)|`d04b680b3d375646f9b9c76ec23af3f8de55df43c9a72711e5c8f1de23c235f9`|
