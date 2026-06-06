// ============================================================
//  知证 ZK-EduCred —— 隐私 AI 学习能力凭证系统
//  Privacy-Preserving AI Learning Credential on Aleo
//
//  场景：AI 教育/评估系统对学习者打分，但学习者的原始数据与
//        具体分数属于敏感隐私，不应公开上链。本合约让：
//        - AI 评估方签发「加密分数凭证」（链上不可见分数）
//        - 学习者用零知识证明「我的分数达标」而不泄露具体分数
//        - 链上只公开「某学科累计有多少人达标」的聚合统计
//
//  作者：CJY 陈俊烨 (1739467001-svg)
//  Aleo 101 Bootcamp · Task 4
// ============================================================
program zk_ai_educred_cjy.aleo {

    // 隐私学习能力凭证：由 AI 评估方签发
    // Record 在链上加密，仅 owner（学习者）持私钥可解密
    record Credential {
        owner: address,    // 学习者地址
        subject: field,    // 学科 / 能力领域标识（哈希值）
        score: u8,         // AI 评估分数 0-100（私密！链上加密不可见）
        issuer: address,   // 签发方（AI 评估系统）地址
    }

    // 公开聚合统计：每个学科「达标认证」的累计人数
    // 链上完全公开可验证，但无法关联到任何个人或其具体分数
    mapping certified_count: field => u64;

    @noupgrade
    constructor() {}

    // ----------------------------------------------------------
    // 1) 签发隐私凭证
    //    由 AI 评估方调用，把评估分数封装进加密 Record 发给学习者。
    //    分数从生成那一刻起就是私密的，链上观察者看不到。
    // ----------------------------------------------------------
    fn issue_credential(learner: address, subject: field, score: u8) -> Credential {
        // 约束：分数必须在合法区间 0-100
        assert(score <= 100u8);
        return Credential {
            owner: learner,
            subject: subject,
            score: score,
            issuer: self.caller,
        };
    }

    // ----------------------------------------------------------
    // 2) 零知识达标证明（核心杀手锏）
    //    学习者用自己的隐私凭证，证明「分数 >= 阈值」。
    //    - ZK 约束保证：分数不足者无法生成有效证明（无法作弊）
    //    - 隐私保证：具体分数 score 全程不出现在链上/输出中
    //    成功后，链上对应学科的「达标人数」+1（聚合公开、个人匿名）
    // ----------------------------------------------------------
    fn prove_qualified(cred: Credential, threshold: u8) -> Final {
        // 关键约束：在零知识电路内验证 score >= threshold
        // 若不成立，证明生成失败 —— 既无法暴露分数，也无法伪造达标
        assert(cred.score >= threshold);

        // 记录涉及的字段必须先取出，才能进入链上 final 块
        let subj: field = cred.subject;
        return final {
            let current: u64 = certified_count.get_or_use(subj, 0u64);
            certified_count.set(subj, current + 1u64);
        };
    }
}
