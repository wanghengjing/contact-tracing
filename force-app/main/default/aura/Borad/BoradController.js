({
    doInit : function(component, event, helper) {

        let gameMode = component.get("v.mode");
        let column = 0;
        if(gameMode && gameMode === "easy"){
            column = 3;
        }else if(gameMode === "medium"){
            column = 4;
        }else {
            column = 6;
        }

        let columnSize = 12/column;
        component.set("v.columnSize",columnSize);
        let words = helper.getWords(column * column);
        component.set("v.words",words);
        let winword = helper.getWinWord(words);
        component.set("v.winWord",winword); 
        console.log(words);
        console.log(winword);
    }
})
