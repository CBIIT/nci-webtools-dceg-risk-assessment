var terms = {
    vegetable: {
        fullName: "Vegetables",
        definition: "INCLUDE raw, cooked, canned, and frozen vegetables (including beans) and leafy green salads. \n DO NOT INCLUDE fried vegetables like French fries or fried potatoes."
    },
    colon: {
        fullName: "Colonoscopy",
        definition: "Examination of the inside of the colon using a colonoscope, inserted into the rectum. A colonoscope is a thin, tube-like instrument with a light and a lens for viewing. It may also have a tool to remove tissue to be checked under a microscope for signs of disease."
    },
    sig: {
        fullName: " Sigmoidoscopy",
        definition: "Examination of the lower colon using a sigmoidoscope, inserted into the rectum. A sigmoidoscope is a thin, tube-like instrument with a light and a lens for viewing. It may also have a tool to remove tissue to be checked under a microscope for signs of disease. Also called proctosigmoidoscopy."
    },
    polyp: {
        fullName: "Polyp",
        definition: "A polyp is a small growth, like a skin tag, that develops on the inside of the colon or rectum."
    },
    asprin: {
        fullName: "Medications containing Asprin",
        definition: "Ex. Bufferin, Bayer, Excedrin or Other generic form"
    },
    "non_asprin": {
        fullName: "Medications NOT containing Asprin",
        definition: "Ex. Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen or Nuprin"
    },
    race_info: {
        fullName: "",
        definition: "When we first developed this tool, we tested it with white people and found it to be accurate in estimating their risk of colorectal cancer. If you are African American, Asian American/Pacific Islander, or Hispanic/Latino, this tool can still estimate your risk. But, because there is not as much data available for these groups, your results may be less accurate.\n In the future, we hope to make this tool more accurate for African Americans, Asian Americans/Pacific Islanders, and Hispanics/Latinos, as researchers complete studies that will provide information to update the tool for these groups.\n Although the tool is not perfect, the information you learn from using it can still help you and your doctor better understand your risk of colorectal cancer."
    },
    hrt: {
        fullName: "Hormone Replacement Therapy (HRT)",
        definition: "Hormones (estrogen, progesterone, or both) given to women after menopause to replace the hormones no longer produced by the ovaries. Also called HRT and menopausal hormone therapy."
    },
    aid: {
        fullName: "anti-inflammatory",
        definition: "Having to do with reducing inflammation."
    },
    moderate: {
        fullName: "Moderate Activity",
        definition: "Moderate activities DO NOT cause you to sweat or breathe hard.\n Some examples include vacuuming, gardening, easy walking for exercise, and so on."
    },
    vigorous: {
        fullName: "Vigorous Activity",
        definition: "Vigorous activities include all activities that DO cause you to sweat or breathe hard.\n Some examples include racquet sports, basketball, running, fast biking, exercise class, weight lifting, backpacking, swimming, and heavy labor such as shoveling dirt."
    }
};

$(function(){
    $.extend($_Glossary, terms);

    $(document).on("click",".termToDefine", termDisplay );
});
