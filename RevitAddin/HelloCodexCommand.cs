using Autodesk.Revit.UI;
using Autodesk.Revit.DB;

namespace HelloCodex
{
    [Autodesk.Revit.Attributes.Transaction(Autodesk.Revit.Attributes.TransactionMode.Manual)]
    public class HelloCodexCommand : IExternalCommand
    {
        public Result Execute(ExternalCommandData commandData, ref string message, ElementSet elements)
        {
            TaskDialog.Show("Hello Codex", "Hello Codex!");
            return Result.Succeeded;
        }
    }
}

