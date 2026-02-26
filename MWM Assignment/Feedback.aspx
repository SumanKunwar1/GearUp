<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="MWM_Assignment.Feedback" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title" class="container" style="min-height: 65vh">
        <div class="row g-0">
            <div class="row g-0 my-3">
                <h3 class="text-secondary">HELP US IMPROVE</h3>
                <hr />
            </div>
            <div class="row mb-3">
                <asp:TextBox runat="server" ID="txtFeedback" CssClass="form-control" TextMode="MultiLine" Style="min-height: 20rem;" placeholder="Share with us your feedback to help us improve our website."></asp:TextBox>
                <asp:CheckBox runat="server" ID="cbShareUser" Text="Send anonymously" CssClass="form-check text-secondary" />
            </div>
            <div class="row justify-content-end">
                <asp:Button runat="server" ID="btnSendFeedback" CssClass="btn btn-primary" Style="max-width: 5rem;" Text="Submit" OnClick="btnSendFeedback_Click" />
            </div>
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
    </main>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="JSContent" runat="server">
</asp:Content>
