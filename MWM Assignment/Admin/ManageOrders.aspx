<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageOrders.aspx.cs" Inherits="MWM_Assignment.Admin.ManageOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="mx-5 p-5">
        <div class="row">
            <div class="col">
                <h3 class="text-secondary">ORDERS</h3>
            </div>
            <div class="col">
                <ul class="nav nav-pills justify-content-center justify-content-md-end text-center" id="myTab" role="tablist">
                    <li class="nav-item">
                        <a href="?ordertab=1" runat="server" class="nav-link" id="hPaid">To Ship</a>
                    </li>
                    <li class="nav-item">
                        <a href="?ordertab=2" runat="server" class="nav-link" id="hReceived">Shipped Out</a>
                    </li>
                    <li class="nav-item">
                        <a href="?ordertab=3" runat="server" class="nav-link" id="hCompleted">Delivered</a>
                    </li>
                    <li class="nav-item">
                        <a href="?ordertab=4" runat="server" class="nav-link" id="hCancelled">Cancelled</a>
                    </li>
                </ul>
            </div>
        </div>
        <hr />

        <div class="mb-5">
            <asp:ListView runat="server" ID="lvOrder" OnPagePropertiesChanging="lvOrder_PagePropertiesChanging">
                <LayoutTemplate>
                    <table class="table table-hover table-responsive">
                        <thead>
                            <tr>
                                <th>No.</th>
                                <th>Order Reference No.</th>
                                <th style="min-width: 400px;">Order Details</th>
                                <th style="min-width: 125px;">Subtotal</th>
                                <th style="min-width: 125px;">Customer</th>
                                <th style="min-width: 150px;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr id="itemPlaceholder" runat="server"></tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="7" style="text-align: end">
                                    <asp:DataPager runat="server" ID="dpOrder" PagedControlID="lvOrder" PageSize="10">
                                        <Fields>
                                            <asp:NumericPagerField ButtonType="Button" CurrentPageLabelCssClass="btn btn-secondary" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                        </tfoot>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Container.DataItemIndex + 1 %></td>
                        <td id="oid-<%# Container.DataItemIndex %>"><%# Eval("oid") %></td>
                        <td>
                            <ul class="list-unstyled">
                                <asp:ListView ID="lvProducts" runat="server" DataSource='<%# getProductFromOrders(Eval("oid").ToString()) %>'>
                                    <ItemTemplate>
                                        <li class="mb-1">
                                            <div class="row align-items-center bg-white rounded">
                                                <div class="col-auto">
                                                    <img src='<%# Eval("image") %>' runat="server" alt='<%# Eval("name") %>' style="height: 5rem; width: 5rem; object-fit: cover" />
                                                </div>
                                                <div class="col">
                                                    <span><%# Eval("name") %></span>
                                                </div>
                                            </div>
                                        </li>
                                    </ItemTemplate>
                                </asp:ListView>
                            </ul>
                        </td>
                        <td class='<%# Eval("status").ToString() != "Cancelled"? "text-success": "text-danger" %>'><%# string.Format("{0:C}", getSubtotal(Eval("oid").ToString())) %></td>
                        <td>
                            <p><%# Eval("name") %></p>
                            <p class="small text-muted"><%# Eval("contact") %></p>
                            <p class="small text-muted"><%# Eval("address") %></p>
                        </td>
                        <td>
                            <%--Paid Actions--%>
                            <div class='row <%# Eval("status").ToString() != "Paid"? "d-none": "" %>'>

                                <button type="button" class="btn btn-primary w-100 mb-1 p-1" onclick='shipOrder(<%# Container.DataItemIndex %>)' data-bs-toggle="modal" data-bs-target="#modalStatic">
                                    <i class="bi bi-truck"></i><p>Ship Out</p>
                                </button>

                                <button type="button" class='btn btn-danger w-100 p-1' onclick='cancelOrder(<%# Container.DataItemIndex %>' data-bs-toggle="modal" data-bs-target="#modalStatic">
                                    <i class='bi bi-x-circle'></i><p>Cancel Order</p>
                                </button>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="row mb-5 justify-content-center align-content-center text-center">
                        <img src="~/Images/Placeholder/noOrders.png" runat="server" alt="No Orders Found" style="height: 12rem; width: 12rem;" />
                        <p>No Orders Found</p>
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>

        <div hidden>
            <asp:Button runat="server" ID='btnCancel' OnClick="btnCancel_Click" />
            <asp:Button runat="server" ID='btnShip' OnClick="btnShip_Click" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfOid" />
            <asp:HiddenField runat="server" ClientIDMode="Static" ID="hfMode" />
        </div>

        <!-- Modal -->
        <div class="modal fade" id="modalStatic" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel">Cancel</h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p id="modalbodycontent" button-mode="">
                            Are you sure you want to cancel this order? This cannot be undone!
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" onclick="clickButton()">Yes</button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Modal -->

    </div>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">
    <script>

        function test() {
            console.log("test")
        }

        function shipOrder(row) {

            oid = document.getElementById("oid-" + row).innerText

            document.getElementById("<%= hfOid.ClientID %>").value = oid;
            document.getElementById("<%= hfMode.ClientID %>").value = "ship";

            document.getElementById("staticBackdropLabel").innerText = "Ship Order"
            document.getElementById("modalbodycontent").innerText = "Mark this order as shipped? This cannot be undone.";
        }

        function cancelOrder(row) {
            oid = document.getElementById("oid-" + row).innerText

            document.getElementById("<%= hfOid.ClientID %>").value = oid
            document.getElementById("<%= hfOid.ClientID %>").value = "cancel"

            document.getElementById("staticBackdropLabel").innerText = "Cancel Order"
            document.getElementById("modalbodycontent").innerText = "Cancel this order? This cannot be undone."
        }

        function clickButton() {

            var buttonMode = document.getElementById("<%= hfMode.ClientID %>").value
            console.log(buttonMode)

            if (buttonMode == "ship") {
                document.getElementById('<%= btnShip.ClientID %>').click();
                return;
            }

            if (buttonMode == "cancel") {
                document.getElementById('<%= btnCancel.ClientID %>').click();
                return;
            }
        }
    </script>

</asp:Content>
