({
    startGame : function (cmp, event, helper) {
        let gameModeComboBox = cmp.find("gameMode");
        let gameMode = gameModeComboBox.get("v.value");
        cmp.set("v.selectMode",gameMode);

        
    },
    reshuffleBoard : function (cmp, event, helper) {
        let gameModeComboBox = cmp.find("gameMode");
        let n1 = gameModeComboBox.get("v.variant");
        alert(n1);
    },
});