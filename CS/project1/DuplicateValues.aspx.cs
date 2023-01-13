using DevExpress.Web;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class DuplicateValues : System.Web.UI.Page {
    protected void Page_Init(object sender, EventArgs e) {

    }

    protected void Grid_CustomJSProperties(object sender, ASPxGridViewClientJSPropertiesEventArgs e) {
        var columnNamesThatShouldHaveUniqueValues = new[] { "CategoryName", "Description" };

        var editColumns = Grid.DataColumns.Where(c => columnNamesThatShouldHaveUniqueValues.Contains(c.FieldName));
        var uniqueValues = new Dictionary<int, object[]>();
        foreach(var column in editColumns) {
            var columnValues = new List<object>();
            for(int visibleIndex = 0; visibleIndex < Grid.VisibleRowCount; visibleIndex++) { 
                if(!Grid.IsGroupRow(visibleIndex))
                    columnValues.Add(Grid.GetRowValues(visibleIndex, column.FieldName));
            }
            if(columnValues.Count != columnValues.Distinct().Count())
                throw new Exception("The duplicate value found");

            uniqueValues[column.Index] = columnValues.ToArray();
        }
        e.Properties["cpValues"] = uniqueValues;
        e.Properties["cpUniqueColumnNames"] = editColumns.Select(c => c.FieldName).ToArray();
    }
}



   