using Autodesk.Revit.UI;
using Autodesk.Revit.Attributes;

namespace HelloCodex
{
    [Transaction(TransactionMode.Manual)]
    public class HelloCodexCommand : IExternalCommand
    {
        public Result Execute(ExternalCommandData commandData, ref string message, Autodesk.Revit.DB.ElementSet elements)
        {
            TaskDialog.Show("Hello Codex", "Hello Codex!");
            return Result.Succeeded;
        }
    }
}
