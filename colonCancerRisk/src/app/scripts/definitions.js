var terms = {
    test: {
        fullName: "Placeholder",
        definition: "(text here)"
    }

};

$(function(){
    $.extend($_Glossary, terms);

    $(document).on("click",".termToDefine", termDisplay );
});
