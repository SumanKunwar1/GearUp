<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageFeedback.aspx.cs" Inherits="MWM_Assignment.Admin.ManageFeedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mx-5 p-5">
        <div class="row">
            <h3 class="text-secondary">FEEDBACKS</h3>
        </div>
        <hr />
        <div class="mb-5">
            <asp:ListView runat="server" ID="lvFeedback" OnPagePropertiesChanging="lvFeedback_PagePropertiesChanging" OnItemCommand="lvFeedback_ItemCommand">
                <LayoutTemplate>
                    <table class="table table-hover table-responsive">
                        <thead>
                            <tr>
                                <th>No.</th>
                                <th>Feedback</th>
                                <th>Customer</th>
                                <th>Date Submitted</th>
                                <th>Status</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr id="itemPlaceholder" runat="server"></tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="7" style="text-align: end">
                                    <asp:DataPager runat="server" ID="dpFeedback" PagedControlID="lvFeedback" PageSize="10">
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
                        <td id="fid-<%# Container.DataItemIndex %>"><%# Eval("feedback") %></td>
                        <td><%# Eval("uid").ToString() == "" ? "Guest" : Eval("name") %></td>
                        <td><%# Eval("dtAdded") %></td>
                        <td><%# (Eval("active").ToString() == "1" ? "New" : "Read") %></td>
                        <td>
                            <asp:LinkButton ID="LinkButton1" CssClass="btn btn-primary" runat="server" ToolTip="Mark as Read" Visible='<%# Eval("active").ToString() == "1" %>' CommandName="seen" CommandArgument='<%# Eval("id") %>'>
                                <i class='bi bi-eye '></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="LinkButton2" CssClass="btn btn-secondary" runat="server" ToolTip="Mark as not Read" Visible='<%# Eval("active").ToString() == "0" %>' CommandName="unseen" CommandArgument='<%# Eval("id") %>'>
                                <i class='bi bi-eye-slash '></i>
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div class="row mb-5 justify-content-center align-content-center text-center">
                        <img src="~/Images/Placeholder/noData.png" runat="server" alt="No Orders Found" style="height: 12rem; width: 12rem;" />
                        <p>No Feedbacks Found</p>
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
        <!-- Status Message -->
        <div runat="server" id="divStatus" visible="false">
            <div class="position-fixed bottom-0 start-0 w-100" style="z-index: 100">
                <div runat="server" id="statusBg" class="text-center text-md-start py-2 px-3 px-xl-5 align-items-center text-white">
                    <asp:Label runat="server" ID="lblStatusIcon" CssClass="bi-check-circle text-white h2" />
                    <asp:Label runat="server" ID="lblStatus" Text="" />
                </div>
            </div>
        </div>
        <!-- Status Message -->
    </div>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">
</asp:Content>
