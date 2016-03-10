var terms = {
    brca1: {
        fullName: "BRCA1",
        definition: "A gene on chromosome 17 that normally helps to suppress cell growth. A person who inherits certain mutations (changes) in a brca1 gene has a higher risk of getting breast, ovarian, prostate, and other types of cancer."
    },
    brca2: {
        fullName: "BRCA2",
        definition: "A gene on chromosome 13 that normally helps to suppress cell growth. A person who inherits certain mutations (changes) in a brca2 gene has a higher risk of getting breast, ovarian, prostate, and other types of cancer."
    },
    lcis: {
        fullName: "lobular carcinoma in situ (LOB-yoo-lar KAR-sih-NOH-muh in SYE-too)",
        definition: "A condition in which abnormal cells are found in the lobules of the breast. LCIS seldom becomes invasive cancer; however, having lobular carcinoma in situ in one breast increases the risk of developing breast cancer in either breast."
    },
    dcis: {
        fullName: "ductal carcinoma in situ (DUK-tal KAR-sih-NOH-muh in SYE-too)",
        definition: "DCIS. A noninvasive condition in which abnormal cells are found in the lining of a breast duct. The abnormal cells have not spread outside the duct to other tissues in the breast. In some cases, ductal carcinoma in situ may become invasive cancer and spread to other tissues, although it is not known at this time how to predict which lesions will become invasive. Also called intraductal carcinoma."
    },
    menst: {
        fullName: "Menstrual Period (MEN-stroo-al PEER-ee-od)",
        definition: "The periodic discharge of blood and tissue from the uterus. From puberty until menopause, menstruation occurs about every 28 days, but does not occur during pregnancy."
    },
    biopsy: {
        fullName: "Biopsy (BY-op-see)",
        definition: "The removal of cells or tissues for examination by a pathologist. The pathologist may study the tissue under a microscope or perform other tests on the cells or tissue. When only a sample of tissue is removed, the procedure is called an incisional biopsy. When an entire lump or suspicious area is removed, the procedure is called an excisional biopsy. When a sample of tissue or fluid is removed with a needle, the procedure is called a needle biopsy, core biopsy, or fine-needle aspiration."
    },
    ah: {
        fullName: "Atypical Hyperplasia (AY-TIP-i-kul hy-per-PLAY-zha)",
        definition: "A benign (noncancerous) condition in which cells look abnormal under a microscope and are increased in number."
    },
    ibc: {
        fullName: "invasive breast cancer (in-VAY-siv brest KAN-ser)",
        definition: "Cancer that has spread from where it started in the breast into surrounding, healthy tissue. Most invasive breast cancers start in the ducts (tubes that carry milk from the lobules to the nipple). Invasive breast cancer can spread to other parts of the body through the blood and lymph systems. Also called infiltrating breast cancer."
    },

};

$(function () {
    $.extend($_Glossary, terms);

    $(document).on("click", ".termToDefine", termDisplay);
});
