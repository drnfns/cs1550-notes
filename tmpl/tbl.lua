-- wide tables scroll in a wrapper so <table> keeps its table role
function Table(t) return pandoc.Div(t, {class = 'tbl'}) end
