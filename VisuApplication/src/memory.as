// Include class only needed by module and which can cause memory leaks
// Use -keep-generated and inspect code source to track memory leaks.
import mx.controls.List;
import mx.managers.DragManager;
import mx.managers.PopUpManager;

private var popUpManager:PopUpManager; 
private var dragManager:DragManager;
private var list:List;