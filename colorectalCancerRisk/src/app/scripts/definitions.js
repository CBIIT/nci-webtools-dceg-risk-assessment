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
    aspirin: {
        fullName: "Medications containing Asprin",
        definition: "Ex. Bufferin, Bayer, Excedrin or Other generic form"
    },
    "non_aspirin": {
        fullName: "Medications NOT containing Asprin",
        definition: "Ex. Advil, Aleve, Celebrex, Ibuprofen, Motrin, Naproxen or Nuprin"
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
