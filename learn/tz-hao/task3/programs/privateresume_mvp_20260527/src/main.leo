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
