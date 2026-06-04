# Task 4 - 部署到测试网并完成链上交互

## 交付材料

### 1. Leo 程序源码

`task3/programs/privateresume_mvp_20260527/src/main.leo`

```leo
program privateresume_mvp_20260527.aleo {

record Resume {
    owner: address,
    solidity: bool,
    react: bool,
    years: u8,
}

@noupgrade
constructor() {}

fn create_resume(
    solidity: bool,
    react: bool,
    years: u8,
) -> Resume {
    return Resume {
        owner: self.signer,
        solidity,
        react,
        years,
    };
}

fn verify(
    resume: Resume,
    min_years: u8,
) -> bool {
    return resume.solidity && resume.years >= min_years;
}

}
```

### 2. 测试网合约地址

```
privateresume_mvp_20260527.aleo
```

部署地址: `aleo1hxrwn37uvt8jm5cks6wvxk44vx6vcgtmvwcsygqamuq6gr4ywuxs000q0w`

网络: `testnet` (Consensus Version 14)

### 3. 链上交互记录

| 操作 | 交易 ID |
|------|---------|
| 部署合约 | `at1y2ksvylcqsnxfg3juuh3r6r8ttjuwjtwe835f0pr7fu0nmrgf58sa6kf3k` |
| create_resume | `at18wcrf999ncent7v454tv83a3uspcupq9k77el3g4naxdsnvqpqpq25k3y7` |

可在 https://explorer.provable.com 搜索以上交易 ID 查看链上详情。

### 4. 截图

![部署截图](<屏幕截图 2026-06-01 115617.png>)

![链上交互截图](<屏幕截图 2026-06-01 115806.png>)

![合约详情截图](<屏幕截图 2026-06-01 115830.png>)

### 5. 部署命令

```bash
cd task3/programs/privateresume_mvp_20260527
leo build
leo deploy --network testnet --broadcast --yes
```
