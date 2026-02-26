<%@ Page Title="" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="ManageUsers.aspx.cs" Inherits="MWM_Assignment.Admin.ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="mx-5 p-5">

        <div class="row">
            <h3 class="text-secondary">MANAGE USERS</h3>
        </div>
        <hr />

        <div runat="server" id="divUserDetails" visible="false">
            <div class="row my-5">
                <div class="col-12 col-md">
                    <h5 class="text-muted">PROFILE PICTURE</h5>
                    <hr />
                    <div class="mb-3 position-relative">
                        <img id="profileImage" runat="server" src="~/Images/Placeholder/placeholder-user.jpg" alt="Profile Image" class="profile-image" clientidmode="Static" />
                        <asp:FileUpload runat="server" ID="fuProfile" ClientIDMode="Static" CssClass="d-none" onchange="img();" />
                        <div class="d-flex justify-content-center align-items-center profile-image-overlay" onclick="chooseFile()">
                            <i class="bi-pencil-square text-white"></i>
                        </div>
                    </div>
                </div>
                <div class="col-12 col-md">
                    <h5 class="text-muted">PERSONAL INFORMATION</h5>
                    <hr />
                    <div class="row">
                        <div class="col-12 col-md">
                            <!-- Name input -->
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="John Doe" Style="min-width: 100%" />
                                <asp:Label runat="server" ID="lblName" AssociatedControlID="txtName" CssClass="form-label" Text="Name" />
                            </div>
                        </div>
                        <div class="col-12 col-md">
                            <!-- Contact input -->
                            <div class="form-floating mb-3">
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="012-34567890" Style="min-width: 100%" />
                                <asp:Label runat="server" ID="lblPhone" AssociatedControlID="txtPhone" CssClass="form-label" Text="Contact" />
                            </div>
                        </div>
                    </div>

                    <!-- Address input -->
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder=" " Style="height: 8rem; min-width: 100%" />
                        <asp:Label runat="server" ID="lblAddress" AssociatedControlID="txtName" CssClass="form-label" Text="Address" />
                    </div>
                </div>
                <div class="col-12 col-md">
                    <h5 class="text-muted">ACCOUNT INFORMATION</h5>
                    <hr />
                    <!-- Email input -->
                    <div class="form-floating mb-3">
                        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control text-muted" TextMode="Email" autocomplete="off" ReadOnly="true" placeholder="example@example.com" Style="min-width: 100%" />
                        <asp:Label runat="server" ID="lblEmail" AssociatedControlID="txtEmail" CssClass="form-label" Text="Email Address" />
                    </div>
                </div>
            </div>
            <div class="row mt-5">
                <div class="col text-center">
                    <asp:Button runat="server" ID="btnUpdate" Text="Update Details" CssClass="btn btn-primary btn-lg" OnClick="btnUpdate_Click" />
                </div>
            </div>
        </div>

        <div class="mb-5">
            <asp:ListView ID="lvUser" runat="server" DataKeyNames="ID" OnItemCommand="lvUser_ItemCommand" OnPagePropertiesChanging="lvUser_PagePropertiesChanging">
                <LayoutTemplate>
                    <table class="table table-hover table-responsive">
                        <thead>
                            <tr>
                                <th>No.</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th style="min-width: 200px;">Address</th>
                                <th>Contact</th>
                                <th>Status</th>
                                <th style="min-width: 125px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr id="itemPlaceholder" runat="server"></tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="7" style="text-align: end">
                                    <asp:DataPager runat="server" ID="dpUser" PagedControlID="lvUser" PageSize="10">
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
                        <td><%# Eval("name") %></td>
                        <td><%# Eval("email") %></td>
                        <td><%# Eval("address") %></td>
                        <td><%# Eval("contact") %></td>
                        <td><%# int.Parse(Eval("active").ToString()) == 1 ? "Active" : "Inactive" %></td>
                        <td>
                            <div class="row">
                                <div class="col-auto">
                                    <asp:LinkButton ID="LinkButton1" CssClass="btn btn-primary" runat="server" CommandName="updateUser" CommandArgument='<%# Eval("id") %>'><i class="bi bi-pencil-square"></i></asp:LinkButton>
                                </div>
                                <div class="col-auto">
                                    <asp:LinkButton ID="LinkButton2" CssClass='btn btn-danger' runat="server" CommandName='<%# int.Parse(Eval("active").ToString()) == 1 ? "deleteUser" : "restoreUser" %>' CommandArgument='<%# Eval("id") %>'><i class='bi <%# int.Parse(Eval("active").ToString()) == 1 ? "bi-trash" : "bi-arrow-counterclockwise" %>'></i></asp:LinkButton>
                                </div>
                            </div>
                        </td>
                    </tr>
                </ItemTemplate>
            </asp:ListView>
        </div>
    </div>

    <!-- Hidden Fields -->
    <div hidden>
        <asp:HiddenField runat="server" ID="hfUid" Value="" />
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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">

    <script type="text/javascript">

        function chooseFile() {
            document.getElementById("fuProfile").click();
        }

        function img() {
            var url = inputToURL(document.getElementById("fuProfile"));
            document.getElementById("profileImage").src = url;
        }

        function inputToURL(inputElement) {
            var file = inputElement.files[0];
            return window.URL.createObjectURL(file);
        }

    </script>

</asp:Content>
