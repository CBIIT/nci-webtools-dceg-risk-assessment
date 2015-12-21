    var terms = {
        ah: {
            fullName: "atypical hyperplasia (AY-TIP-i-kul hy-per-PLAY-zha)",
            definition: "A benign (noncancerous) condition in which cells look abnormal under a microscope and are increased in number."
        },
        bcc: {
            fullName: "Basal Cell Carcinoma (BAY-sal sel KAR-sih-NOH-muh)",
            definition: "A type of skin cancer that arises from the basal cells, small round cells found in the lower part (or base) of the epidermis, the outer layer of the skin."
        },
        is: {
            fullName: "Immune System (im-YOON)",
            definition: "The complex group of organs and cells that defends the body against infections and other diseases."
        },
        rf: {
            fullName: "Risk Factor",
            definition: "Something that may increase the chance of developing a disease. Some examples of risk factors for cancer include age, a family history of certain cancers, use of tobacco products, certain eating habits, obesity, lack of exercise, exposure to radiation or other cancer-causing agents, and certain genetic changes."
        },
        uvb: {
            fullName: "UVB Radiation",
            definition: "A type of ultraviolet (UV) radiation. UV rays are invisible rays that are part of the energy that comes from the sun. UVB radiation causes sunburn, and scientists have long thought that it can cause melanoma and other types of skin cancer. Skin specialists recommend that people use sunscreens that reflect, absorb, or scatter ultraviolet radiation."
        },
        uva: {
            fullName: "UVA Radiation",
            definition: "A type of ultraviolet (UV) radiation. UV rays are invisible rays that are part of the energy that comes from the sun. UVA radiation also comes from sun lamps and tanning beds. Scientists think that UVA radiation may cause skin damage that can lead to skin cancer and premature aging. For this reason, skin specialists recommend that people use sunscreens that reflect, absorb, or scatter ultraviolet radiation."
        },
        uv: {
            fullName: "Ultraviolet Radiation (ul-tra-VYE-o-let ray-dee-AY-shun)",
            definition: "UV radiation. Invisible rays that are part of the energy that comes from the sun. UV radiation also comes from sun lamps and tanning beds. UV radiation can damage the skin and cause melanoma and other types of skin cancer. UV radiation that reaches the Earth's surface is made up of two types of rays, called UVA and UVB rays. UVB rays are more likely than UVA rays to cause sunburn, but UVA rays pass deeper into the skin. Scientists have long thought that UVB radiation can cause melanoma and other types of skin cancer. They now think that UVA radiation also may add to skin damage that can lead to skin cancer and cause premature aging. For this reason, skin specialists recommend that people use sunscreens that reflect, absorb, or scatter both kinds of UV radiation."
        },
        transplant: {
            fullName: "Transplantation",
            definition: "The replacement of tissue with tissue from the person's own body or from another person."
        },

        ss: {
            fullName: "Sunscreen",
            definition: "A substance that helps protect the skin from the sun's harmful rays. Sunscreens reflect, absorb, and scatter both ultraviolet A and B radiation to provide protection against both types of radiation. Using lotions, creams, or gels that contain sunscreens can help protect the skin from premature aging and damage that may lead to skin cancer."
        },

        sc: {
            fullName: "Squamous Cell (SKWAY-mus)",
            definition: "Flat cell that looks like a fish scale under a microscope. These cells cover inside and outside surfaces of the body. They are found in the tissues that form the surface of the skin, the lining of the hollow organs of the body (such as the bladder, kidney, and uterus), and the passages of the respiratory and digestive tracts"
        }

    };

$(function(){
    $.extend($_Glossary, terms);

    $(document).on("click",".termToDefine", termDisplay );
});
