<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="MWM_Assignment.Orders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <main aria-labelledby="title" class="container">
        <div class="justify-content-center align-items-center" style="min-height: 80vh;">
            <div class="row mt-5">
                <div class="col">
                    <h3 class="text-secondary">ORDERS</h3>
                </div>
                <div class="col">
                    <ul class="nav nav-pills justify-content-center justify-content-md-end" id="myTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="ship-tab" data-bs-toggle="tab" data-bs-target="#ship" type="button" role="tab" aria-controls="ship" aria-selected="true">To Ship</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="receive-tab" data-bs-toggle="tab" data-bs-target="#receive" type="button" role="tab" aria-controls="receive" aria-selected="false">To Receive</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="completed-tab" data-bs-toggle="tab" data-bs-target="#completed" type="button" role="tab" aria-controls="completed" aria-selected="false">Completed</button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="cancelled-tab" data-bs-toggle="tab" data-bs-target="#cancelled" type="button" role="tab" aria-controls="cancelled" aria-selected="false">Cancelled</button>
                        </li>
                    </ul>
                </div>
            </div>
            <hr />
            <div class="px-5 py-3">
                <div class="tab-content" id="myTabContent">
                    <div class="tab-pane fade show active" id="ship" role="tabpanel" aria-labelledby="ship-tab">
                        <asp:DataList ID="dlPaid" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
                            <ItemTemplate>

                                <div class="bg-white border-0 shadow-sm p-3 rounded my-3">
                                    <div class="row align-items-center justify-content-between">
                                        <div class="col-auto">
                                            <span class="small text-secondary">Order Reference: </span>
                                            <span id="dlPaid-orderRef-<%# Container.ItemIndex.ToString() %>" class="small text-secondary"><%# Eval("oid") %></span>
                                        </div>
                                        <div class="col text-end">
                                            <span class="text-secondary">| </span>
                                            <asp:Label ID="Label6" runat="server" CssClass="small text-success" Text='<%# Eval("status") %>' />
                                        </div>
                                    </div>
                                    <hr />
                                    <a href="OrderDetails.aspx?oid=<%# Eval("oid") %>" class="nav-link order-cards">
                                        <div class="row">
                                            <div class="col-auto me-3">
                                                <asp:Image ID="Image1" runat="server" CssClass="img-fluid p-2" ImageUrl='<%# Eval("image") %>' Style="height: 8rem; width: 8rem; object-fit: contain" />
                                            </div>
                                            <div class="col py-3">
                                                <div class="row g-0">
                                                    <asp:Label ID="Label1" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                                    <div class="col-auto me-md-5">
                                                        <asp:Label ID="Label2" runat="server" CssClass="h5" Text='<%# Eval("name") %>' />
                                                    </div>
                                                    <div class="col">
                                                        <asp:Label ID="Label3" runat="server" CssClass="small text-secondary" Text='<%# "x" + Eval("qty").ToString().Trim() %>' />
                                                    </div>
                                                </div>
                                                <div class="row my-3">
                                                    <p class="text-muted small"><%# (int.Parse(Eval("items").ToString()) == 1 ? "" : "+ " + (int.Parse(Eval("items").ToString()) -1).ToString() + " other item(s).") %></p>
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-auto py-3">
                                                <div class="row g-0 text-end">
                                                    <asp:Label ID="Label9" runat="server" CssClass="text-secondary" Text='<%# Eval("price", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                    <hr />
                                    <div class="row mb-3">
                                        <div class="col text-end align-items-end">
                                            <div class="row g-0">
                                                <div class="col text-start">
                                                    <asp:Label ID="Label5" runat="server" CssClass="small text-secondary " Text='<%# Eval("dtAdded") %>' />
                                                </div>
                                                <div class="col text-end">
                                                    <span>Order Total: </span>
                                                    <asp:Label ID="Label7" runat="server" CssClass="h5 text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col text-end align-items-end">
                                            <div class="row g-0">
                                                <div class="col text-end">
                                                    <button type="button" id="modalButton" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalStatic" onclick="getPaidOrderRef(<%# Container.ItemIndex.ToString() %>)">Cancel Order</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <div class="row mb-5 justify-content-center align-content-center text-center <%# (dlPaid.Items.Count != 0) ? "d-none" : ""%>">
                                    <img src="~/Images/Placeholder/noOrders.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                                    <p>No Orders Found</p>
                                </div>
                            </FooterTemplate>
                        </asp:DataList>
                    </div>
                    <div class="tab-pane fade" id="receive" role="tabpanel" aria-labelledby="receive-tab">
                        <asp:DataList ID="dlShipped" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
                            <ItemTemplate>

                                <div class="bg-white border-0 shadow-sm p-3 rounded my-3">
                                    <div class="row align-items-center justify-content-between">
                                        <div class="col-auto">
                                            <span class="small text-secondary">Order Reference: </span>
                                            <span id="dlShipped-orderRef-<%# Container.ItemIndex.ToString() %>" class="small text-secondary"><%# Eval("oid") %></span>
                                        </div>
                                        <div class="col text-end">
                                            <span class="text-secondary">| </span>
                                            <asp:Label ID="Label6" runat="server" CssClass="small text-success" Text='<%# Eval("status") %>' />
                                        </div>
                                    </div>
                                    <hr />
                                    <a href="OrderDetails.aspx?oid=<%# Eval("oid") %>" class="nav-link order-cards">
                                        <div class="row">
                                            <div class="col-auto me-3">
                                                <asp:Image ID="Image1" runat="server" CssClass="img-fluid p-2" ImageUrl='<%# Eval("image") %>' Style="height: 8rem; width: 8rem; object-fit: contain" />
                                            </div>
                                            <div class="col py-3">
                                                <div class="row g-0">
                                                    <asp:Label ID="Label1" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                                    <div class="col-auto me-md-5">
                                                        <asp:Label ID="Label2" runat="server" CssClass="h5" Text='<%# Eval("name") %>' />
                                                    </div>
                                                    <div class="col">
                                                        <asp:Label ID="Label3" runat="server" CssClass="small text-secondary" Text='<%# "x" + Eval("qty").ToString().Trim() %>' />
                                                    </div>
                                                </div>
                                                <div class="row my-3">
                                                    <p class="text-muted small"><%# (int.Parse(Eval("items").ToString()) == 1 ? "" : "+ " + (int.Parse(Eval("items").ToString()) -1).ToString() + " other item(s).") %></p>
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-auto py-3">
                                                <div class="row g-0 text-end">
                                                    <asp:Label ID="Label9" runat="server" CssClass="text-secondary" Text='<%# Eval("price", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                    <hr />
                                    <div class="row mb-3">
                                        <div class="col text-end align-items-end">
                                            <div class="row g-0">
                                                <div class="col text-start">
                                                    <asp:Label ID="Label5" runat="server" CssClass="small text-secondary " Text='<%# Eval("dtAdded") %>' />
                                                </div>
                                                <div class="col text-end">
                                                    <span>Order Total: </span>
                                                    <asp:Label ID="Label7" runat="server" CssClass="h5 text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col text-end align-items-end">
                                            <div class="row g-0">
                                                <div class="col text-end">
                                                    <button type="button" id="modalButton" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalStatic" onclick="getShippedOrderRef(<%# Container.ItemIndex.ToString() %>)">Order Received</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <div class="row mb-5 justify-content-center align-content-center text-center <%# (dlShipped.Items.Count != 0) ? "d-none" : ""%>">
                                    <img src="~/Images/Placeholder/noOrders.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                                    <p>No Orders Found</p>
                                </div>
                            </FooterTemplate>
                        </asp:DataList>
                    </div>
                    <div class="tab-pane fade" id="completed" role="tabpanel" aria-labelledby="completed-tab">
                        <asp:DataList ID="dlDelivered" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
                            <ItemTemplate>

                                <div class="bg-white border-0 shadow-sm p-3 rounded my-3">
                                    <div class="row align-items-center justify-content-between">
                                        <div class="col-auto">
                                            <span class="small text-secondary">Order Reference: </span>
                                            <span id="dlDelivered-orderRef-<%# Container.ItemIndex.ToString() %>" class="small text-secondary"><%# Eval("oid") %></span>
                                        </div>
                                        <div class="col text-end">
                                            <span class="text-secondary">| </span>
                                            <asp:Label ID="Label6" runat="server" CssClass="small text-success" Text='<%# Eval("status") %>' />
                                        </div>
                                    </div>
                                    <hr />
                                    <a href="OrderDetails.aspx?oid=<%# Eval("oid") %>" class="nav-link order-cards">
                                        <div class="row">
                                            <div class="col-auto me-3">
                                                <asp:Image ID="Image1" runat="server" CssClass="img-fluid p-2" ImageUrl='<%# Eval("image") %>' Style="height: 8rem; width: 8rem; object-fit: contain" />
                                            </div>
                                            <div class="col py-3">
                                                <div class="row g-0">
                                                    <asp:Label ID="Label1" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                                    <div class="col-auto me-md-5">
                                                        <asp:Label ID="Label2" runat="server" CssClass="h5" Text='<%# Eval("name") %>' />
                                                    </div>
                                                    <div class="col">
                                                        <asp:Label ID="Label3" runat="server" CssClass="small text-secondary" Text='<%# "x" + Eval("qty").ToString().Trim() %>' />
                                                    </div>
                                                </div>
                                                <div class="row my-3">
                                                    <p class="text-muted small"><%# (int.Parse(Eval("items").ToString()) == 1 ? "" : "+ " + (int.Parse(Eval("items").ToString()) -1).ToString() + " other item(s).") %></p>
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-auto py-3">
                                                <div class="row g-0 text-end">
                                                    <asp:Label ID="Label9" runat="server" CssClass="text-secondary" Text='<%# Eval("price", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                    <hr />
                                    <div class="row mb-3">
                                        <div class="col text-end align-items-end">
                                            <div class="row g-0">
                                                <div class="col text-start">
                                                    <asp:Label ID="Label5" runat="server" CssClass="small text-secondary " Text='<%# Eval("dtAdded") %>' />
                                                </div>
                                                <div class="col text-end">
                                                    <span>Order Total: </span>
                                                    <asp:Label ID="Label7" runat="server" CssClass="h5 text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col text-end align-items-end">
                                            <div class='row g-0 <%# checkReviewExist(Eval("oid").ToString()) ? "d-none": "" %>'>
                                                <div class="col text-end">
                                                    <button type="button" id="modalButton" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#modalStatic" onclick="getDeliveredOrderRef(<%# Container.ItemIndex.ToString() %>)">Rate</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <div class="row mb-5 justify-content-center align-content-center text-center <%# (dlDelivered.Items.Count != 0) ? "d-none" : ""%>">
                                    <img src="~/Images/Placeholder/noOrders.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                                    <p>No Orders Found</p>
                                </div>
                            </FooterTemplate>
                        </asp:DataList>
                    </div>
                    <div class="tab-pane fade" id="cancelled" role="tabpanel" aria-labelledby="cancelled-tab">
                        <asp:DataList ID="dlCancelled" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
                            <ItemTemplate>

                                <div class="bg-white border-0 shadow-sm p-3 rounded my-3">
                                    <div class="row align-items-center justify-content-between">
                                        <div class="col-auto">
                                            <span class="small text-secondary">Order Reference: </span>
                                            <span id="dlCancelled-orderRef-<%# Container.ItemIndex.ToString() %>" class="small text-secondary"><%# Eval("oid") %></span>
                                        </div>
                                        <div class="col text-end">
                                            <span class="text-secondary">| </span>
                                            <asp:Label ID="Label6" runat="server" CssClass="small text-danger" Text='<%# Eval("status") %>' />
                                        </div>
                                    </div>
                                    <hr />
                                    <a href="OrderDetails.aspx?oid=<%# Eval("oid") %>" class="nav-link order-cards">
                                        <div class="row">
                                            <div class="col-auto me-3">
                                                <asp:Image ID="Image1" runat="server" CssClass="img-fluid p-2" ImageUrl='<%# Eval("image") %>' Style="height: 8rem; width: 8rem; object-fit: contain" />
                                            </div>
                                            <div class="col py-3">
                                                <div class="row g-0">
                                                    <asp:Label ID="Label1" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                                    <div class="col-auto me-md-5">
                                                        <asp:Label ID="Label2" runat="server" CssClass="h5" Text='<%# Eval("name") %>' />
                                                    </div>
                                                    <div class="col">
                                                        <asp:Label ID="Label3" runat="server" CssClass="small text-secondary" Text='<%# "x" + Eval("qty").ToString().Trim() %>' />
                                                    </div>
                                                </div>
                                                <div class="row my-3">
                                                    <p class="text-muted small"><%# (int.Parse(Eval("items").ToString()) == 1 ? "" : "+ " + (int.Parse(Eval("items").ToString()) -1).ToString() + " other item(s).") %></p>
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-auto py-3">
                                                <div class="row g-0 text-end">
                                                    <asp:Label ID="Label9" runat="server" CssClass="text-secondary" Text='<%# Eval("price", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </a>
                                    <hr />
                                    <div class="row mb-3">
                                        <div class="col text-end align-items-end">
                                            <div class="row g-0">
                                                <div class="col text-start">
                                                    <asp:Label ID="Label5" runat="server" CssClass="small text-secondary " Text='<%# Eval("dtAdded") %>' />
                                                </div>
                                                <div class="col text-end">
                                                    <span>Order Total: </span>
                                                    <asp:Label ID="Label7" runat="server" CssClass="h5 text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <div class="row mb-5 justify-content-center align-content-center text-center <%# (dlCancelled.Items.Count != 0) ? "d-none" : ""%>">
                                    <img src="~/Images/Placeholder/noOrders.png" runat="server" alt="No Data" style="height: 12rem; width: 12rem;" />
                                    <p>No Orders Found</p>
                                </div>
                            </FooterTemplate>
                        </asp:DataList>
                    </div>
                </div>
            </div>
        </div>

        <div hidden>
            <asp:Button runat="server" ID='btnCancel' OnClick="btnCancel_Click" />
            <asp:Button runat="server" ID='btnReceived' OnClick="btnReceived_Click" />
            <asp:Button runat="server" ID='btnRate' OnClick="btnRate_Click" />
            <asp:Button runat="server" ID='btnBuy' OnClick="btnBuy_Click" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfOid" Value="" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfMode" Value="" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfRating" Value="" />
        </div>

        <!-- Modal -->
        <div class="modal fade" id="modalStatic" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Cancel</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="closeModal()"></button>
                    </div>
                    <div class="modal-body">
                        <p id="modalbodycontent"></p>
                        <asp:Label ID="orderRefModal" ClientIDMode="Static" CssClass="small text-secondary" runat="server"></asp:Label>

                        <div id="divFeedback" class="d-none">
                            <span style="font-size: 2rem;" onmouseout="resetStar()">
                                <i class="bi bi-star" id="ratingStar-1" onmouseover="hoverStar(1)" onclick="clickStar(1)"></i>
                                <i class="bi bi-star" id="ratingStar-2" onmouseover="hoverStar(2)" onclick="clickStar(2)"></i>
                                <i class="bi bi-star" id="ratingStar-3" onmouseover="hoverStar(3)" onclick="clickStar(3)"></i>
                                <i class="bi bi-star" id="ratingStar-4" onmouseover="hoverStar(4)" onclick="clickStar(4)"></i>
                                <i class="bi bi-star" id="ratingStar-5" onmouseover="hoverStar(5)" onclick="clickStar(5)"></i>
                            </span>
                            <span class="text-muted small" id="ratingNum"></span>
                            <asp:TextBox ID="txtReviewDesc" runat="server" placeholder="Leave us a review" CssClass="form-control mw-100" TextMode="MultiLine" Style="height: 8rem;" />
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="closeModal()">Cancel</button>
                        <button type="button" class="btn btn-danger" onclick="clickButton()">Yes</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal -->

        <!-- Status Message -->
        <div runat="server" id="divStatus">
            <div class="position-fixed bottom-0 start-0 w-100">
                <div runat="server" id="statusBg" class="text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white">
                    <asp:Label runat="server" ID="lblStatusIcon" CssClass="bi-check-circle text-white h2" />
                    <asp:Label runat="server" ID="lblStatus" Text="" />
                </div>
            </div>
        </div>
        <!-- Status Message -->
    </main>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">

    <script>
        function getPaidOrderRef(row) {

            var orderRef = document.getElementById("dlPaid-orderRef-" + row).innerText

            document.getElementById("<%= hfOid.ClientID %>").value = orderRef
            document.getElementById("<%= hfMode.ClientID %>").value = "cancel"

            document.getElementById("staticBackdropLabel").innerText = "Cancel"
            document.getElementById("modalbodycontent").innerText = "Are you sure you want to cancel this order? This cannot be undone!"

        }

        function closeModal() {

            document.getElementById("staticBackdropLabel").innerText = ""
            document.getElementById("modalbodycontent").innerText = ""
            document.getElementById("divFeedback").classList = "d-none"

        }

        function getShippedOrderRef(row) {

            var orderRef = document.getElementById("dlShipped-orderRef-" + row).innerText

            document.getElementById("<%= hfOid.ClientID %>").value = orderRef
            document.getElementById("<%= hfMode.ClientID %>").value = "receive"

            document.getElementById("staticBackdropLabel").innerText = "Confirm Delivery"
            document.getElementById("modalbodycontent").innerText = "Mark order as Received? This cannot be undone."

        }

        function getDeliveredOrderRef(row) {

            var orderRef = document.getElementById("dlDelivered-orderRef-" + row).innerText

            document.getElementById("<%= hfOid.ClientID %>").value = orderRef
            document.getElementById("<%= hfMode.ClientID %>").value = "rate"

            document.getElementById("divFeedback").classList = ""
            document.getElementById("staticBackdropLabel").innerText = "Rate your experience with us"
        }

        function clickButton() {

            var buttonMode = document.getElementById("<%= hfMode.ClientID %>").value

            if (buttonMode == "cancel") {
                document.getElementById('<%= btnCancel.ClientID %>').click();
                return;
            }

            if (buttonMode == "receive") {
                document.getElementById('<%= btnReceived.ClientID %>').click();
                return;
            }

            if (buttonMode == "rate") {

                if (document.getElementById('<%= hfRating.ClientID %>').value == "") {
                    document.getElementById("modalbodycontent").innerText = "Please give a rating!"
                    document.getElementById("modalbodycontent").classList = "text-danger"
                    return;
                }

                document.getElementById('<%= btnRate.ClientID %>').click();
                return;
            }

        }

        function clickStar(rating) {

            for (i = rating; i > 0; i--) {
                document.getElementById("ratingStar-" + i).classList = "bi bi-star-fill text-warning"
            }

            for (i = rating + 1; i <= 5; i++) {
                document.getElementById("ratingStar-" + i).classList = "bi bi-star"
            }

            document.getElementById('<%= hfRating.ClientID %>').value = rating

            document.getElementById('ratingNum').innerText = rating + " / 5"
        }

        function hoverStar(rating) {
            for (i = rating; i > 0; i--) {
                document.getElementById("ratingStar-" + i).classList = "bi bi-star-fill text-warning"
            }

            for (i = rating + 1; i <= 5; i++) {
                document.getElementById("ratingStar-" + i).classList = "bi bi-star"
            }
        }

        function resetStar() {

            if (document.getElementById('<%= hfRating.ClientID %>').value != "") {
                return;
            }

            for (i = 1; i <= 5; i++) {
                document.getElementById("ratingStar-" + i).classList = "bi bi-star"
            }
        }

    </script>

</asp:Content>
