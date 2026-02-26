<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderDetails.aspx.cs" Inherits="MWM_Assignment.OrderDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container">
        <div class="pt-3 mb-2">
            <div class="row">
                <h3 class="text-secondary mb-3">ORDER DETAILS</h3>
                <hr />
            </div>
        </div>
        <div class="mb-3">
            <a href='javascript:history.go(-1)' class="text-decoration-none">< Go Back to Previous Page</a>
        </div>
        <div class="px-5 py-3 bg-white rounded shadow-sm mb-3">
            <div class="row">
                <div class="col">
                    <h5 class="fw-bold">Delivery Address:</h5>
                    <asp:Label runat="server" ID="lblName" Text="Placeholder" CssClass="text-secondary fw-bold" />
                    <br />
                    <asp:Label runat="server" ID="lblContact" Text="Placeholder" CssClass="text-muted small" />
                    <br />
                    <asp:Label runat="server" ID="lblAddress" Text="Placeholder" CssClass="text-muted small" />
                </div>
                <div class="col text-end text-success">
                    <i class="bi bi-truck"></i>
                    <asp:Label runat="server" ID="lblStatus" Text="Placeholder" />
                    <br />
                    <asp:Label runat="server" ID="lblDtUpdated" Text="Placeholder" CssClass="small text-muted" />
                </div>
            </div>

            <!-- Continue Heres -->
        </div>

        <div class="px-5 py-3 bg-white rounded shadow-sm mb-3">
            <asp:DataList ID="dlOrders" runat="server" RepeatColumns="1" RepeatDirection="Vertical" Width="100%">
                <HeaderTemplate>
                    <div class="border-0">
                        <div class="row align-items-center">
                            <div class="col-auto me-3" style="min-width: 104px;">
                                <h5 class="fw-bold">Products</h5>
                            </div>
                            <div class="col">
                                <div class="row">
                                    <div class="col-4 d-none d-md-flex">
                                    </div>
                                    <div class="col d-none d-lg-flex">
                                        <h5 class="fw-bold">Unit Price</h5>
                                    </div>
                                    <div class="col d-none d-md-flex">
                                        <h5 class="fw-bold">Quantity</h5>
                                    </div>
                                    <div class="col d-none d-md-flex">
                                        <h5 class="fw-bold">Subtotal</h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr />
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="row align-items-center">
                        <div class="col-auto me-3">
                            <asp:Image ID="Image1" runat="server" CssClass="img-fluid" ImageUrl='<%# Eval("image") %>' Style="height: 5rem; width: 5rem; object-fit: contain" />
                        </div>
                        <div class="col">
                            <div class="row align-items-center">
                                <div class="col-12 col-md-4">
                                    <div class="mb-3">
                                        <asp:Label ID="Label1" runat="server" CssClass="d-none" Text='<%# Eval("pid") %>' />
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("name") %>' />
                                    </div>
                                </div>
                                <div class="col d-none d-lg-flex">
                                    <asp:Label ID="Label5" runat="server" CssClass="text-secondary" Text='<%# Eval("price", "{0:C}") %>' />
                                </div>
                                <div class="col-12 col-md order-2 order-md-1">
                                    <div class="mb-1">
                                        <label class="text-secondary d-md-none">Qty: </label>
                                        <asp:Label ID="Label3" runat="server" Text='<%# Eval("qty") %>' />
                                    </div>
                                </div>
                                <div class="col-12 col-md order-1 order-md-2">
                                    <div class="mb-1">
                                        <label class="text-secondary d-md-none">Subtotal: </label>
                                        <asp:Label ID="Label4" runat="server" CssClass="text-danger" Text='<%# Eval("subtotal", "{0:C}") %>' />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <hr />
                </ItemTemplate>
            </asp:DataList>

        </div>
        <div class="px-5 py-3 bg-white rounded shadow-sm">
            <div class="row">
                <div class="col-md-8">
                </div>
                <div class="col col-md-4 text-end">
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="text-secondary">Merchandise Total:</th>
                                <th>
                                    <asp:Label CssClass="text-secondary" runat="server" ID="lblTotal" Text="" /></th>
                            </tr>
                            <tr>
                                <th class="text-secondary">SST (10%):</th>
                                <th>
                                    <asp:Label CssClass="text-secondary" runat="server" ID="lblTax" Text="" />
                                </th>
                            </tr>
                            <tr>
                                <th class="text-secondary">Grand Sub-Total:</th>
                                <th>
                                    <asp:Label CssClass="h3 fw-bold text-danger" runat="server" ID="lblSubtotal" Text="" />
                                </th>
                            </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">
</asp:Content>
