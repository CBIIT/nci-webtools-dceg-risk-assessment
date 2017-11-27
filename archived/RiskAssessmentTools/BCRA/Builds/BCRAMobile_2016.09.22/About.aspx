<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="About" Codebehind="About.aspx.cs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <tr>
        <td class="h">
            <a id="A2" runat="server" href="~/">&lt; Back</a>
        </td>
    </tr>
    <tr>
        <td class="q">
            <a name="top"></a>About the Tool
        </td>
    </tr>
    <tr>
        <td class="h">
            <ul class="r">
                <li><a href="#info">Information For New Users</a> </li>
                <li><a href="#explain">Explaining the results</a> </li>
                <li><a href="#gail">About the Gail Model</a> </li>
                <li><a href="#ref">References</a> </li>
            </ul>
        </td>
    </tr>
    <tr>
        <td class="q">
            <a name="info"></a>Information For New Users
        </td>
    </tr>
    <tr>
        <td>
            <ul>
                <li>The Breast Cancer Risk Assessment Tool was designed for use by health professionals. If you are not a health professional, you are encouraged to discuss the results and your personal risk of breast cancer with your doctor. </li>
                <li>The tool should not be used to calculate breast cancer risk for women who have already had a diagnosis of breast cancer, lobular carcinoma in situ (LCIS), or ductal carcinoma in situ (DCIS). </li>
                <li>Although the tool has been used with success in clinics for women with strong family histories of breast cancer, more specific methods of estimating risk are appropriate for women known to have breast cancer-producing mutations in the BRCA1 or BRCA2 genes. </li>
                <li>Other factors may also affect risk and are not accounted for by the tool. These factors include previous radiation therapy to the chest for the treatment of Hodgkin lymphoma or recent migration from a region with low breast cancer rates, such as rural China. The tool's risk calculations assume that a woman is screened for breast cancer as in the general U.S. population. A woman who does not have mammograms will have somewhat lower chances of a diagnosis of breast cancer. </li>
            </ul>
        </td>
    </tr>
    <tr>
        <td class="h">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>
    <tr>
        <td class="q">
            <a name="explain"></a>Explaining the results
        </td>
    </tr>
    <tr>
        <td>
            <p>
                The Breast Cancer Risk Assessment Tool will estimate a woman's risk of developing invasive breast cancer during the next 5-year period and up to age 90 (lifetime risk) based on the woman's age and the risk factor information provided. For comparison, the tool will then calculate 5-year and lifetime risk estimates for a woman of the same age who is at average risk for developing breast cancer. Lifetime risk estimates are higher than 5-year estimates because breast cancer risk increases with years at risk.
            </p>
            <p>
                Risk estimates calculated by the tool are estimates of absolute breast cancer risk. Absolute breast cancer risk is the chance or probability of developing invasive breast cancer in a defined age interval. One way to evaluate the accuracy of the risk estimate is to determine whether it correctly predicts average risk in a group of women with the same risk factors and age. The Breast Cancer Risk Assessment Tool does predict such average risks well.
            </p>
            <p>
                Although a woman's risk may be accurately estimated, these predictions do not allow one to say precisely which woman will develop breast cancer. In fact, the distribution of risk estimates for women who develop breast cancer overlaps the estimates of risk for women who do not.
            </p>
        </td>
    </tr>
    <tr>
        <td class="h">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>
    <tr>
        <td class="q">
            <a name="gail"></a>About the Gail Model
        </td>
    </tr>
    <tr>
        <td>
            <p>
                The Breast Cancer Risk Assessment Tool is based on a statistical model known as the "Gail model," which is named after Dr. Mitchell Gail, Senior Investigator in the Biostatistics Branch of NCI's Division of Cancer Epidemiology and Genetics. The model uses a woman's own personal medical history (number of previous breast biopsies and the presence of atypical hyperplasia in any previous breast biopsy specimen), her own reproductive history (age at the start of menstruation and age at the first live birth of a child), and the history of breast cancer among her first-degree relatives (mother, sisters, daughters) to estimate her risk of developing invasive breast cancer over specific periods of time. Data from the Breast Cancer Detection Demonstration Project (BCDDP), which was a joint NCI and American Cancer Society breast cancer screening study that involved 280,000 women aged 35 to 74 years, and from NCI's Surveillance, Epidemiology, and End Results (SEER) Program were used in developing the model. Estimates for African American women were based on data from the Women’s Contraceptive and Reproductive Experiences (CARE) Study and from SEER data. CARE participants included 1,607 women with invasive breast cancer and 1,637 without. Estimates for Asian and Pacific Islander women in the United States were based on data from the Asian American Breast Cancer Study (AABCS) and SEER data. AABCS participants included 597 Asian and Pacific Islander women with invasive breast cancer, and 966 women without breast cancer.
            </p>
            <p>
                The Gail model has been tested in large populations of white women and has been shown to provide accurate estimates of breast cancer risk. In other words, the model has been "validated" for white women. It has also been tested in data from the Women’s Health Initiative for African American women, and the model performs well, but may underestimate risk in African American women with previous biopsies. The model has been validated for Asian and Pacific Islander women in the WHI and data from SEER. The model still needs to be validated for Hispanic women, Asian women, and other subgroups, and results should be interpreted by a health care provider for women with special risk factors, such as women treated for Hodgkin’s disease with radiation to the chest and carriers of gene mutations that increase breast cancer risk. Researchers are conducting additional studies, including studies with minority populations, to gather more data and to test and improve the model.
            </p>
        </td>
    </tr>
    <tr>
        <td class="h">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>
    <tr>
        <td class="q">
            <a name="ref"></a>References
        </td>
    </tr>
    <tr>
        <td>
            <ol>
                <li>Gail MH, Brinton LA, Byar DP, Corle DK, Green SB, Shairer C, Mulvihill JJ: Projecting individualized probabilities of developing breast cancer for white females who are being examined annually. J Natl Cancer Inst 81(24):1879-86, 1989.
                    <br />
                    [<a href="http://pubmedhh.nlm.nih.gov/cgi-bin/abstract.cgi?id=2593165">PubMed Abstract</a>]
                </li>
                <li>Costantino JP, Gail MH, Pee D, Anderson S, Redmond CK, Benichou J, Wieand HS: Validation studies for models projecting the risk of invasive and total breast cancer incidence. J Natl Cancer Inst 91(18):1541-8, 1999.
                    <br />
                    [<a href="http://pubmedhh.nlm.nih.gov/cgi-bin/abstract.cgi?id=10491430">PubMed Abstract</a>]
                </li>
                <li>Gail MH, Costantino JP, Bryant J, Croyle R, Freedman L, Helzlsouer K, Vogel V: Weighing  the risks and benefits of tamoxifen treatment for preventing breast cancer. J Natl Cancer Inst 91(21):1829-46, 1999.
                    <br />
                    [<a href="http://pubmedhh.nlm.nih.gov/cgi-bin/abstract.cgi?id=10547390">PubMed Abstract</a>]
                </li>
                <li>Rockhill B, Spiegelman D, Byrne C, Hunter DJ, Colditz GA: Validation of the Gail et al. model of breast cancer risk prediction and implications for chemoprevention.J Natl Cancer Inst 93(5):358-66, 2001.
                    <br />
                    [<a href="http://pubmedhh.nlm.nih.gov/cgi-bin/abstract.cgi?id=11238697">PubMed Abstract</a>]
                </li>
                <li>Gail MH, Costantino JP, Pee D, Bondy M, Newman L, Selvan M, Anderson GL, Malone KE, Marchbanks PA, McCaskill-Stevens W, Norman SA, Simon MS, Spirtas R, Ursin G, and Bernstein L. Projecting Individualized Absolute Invasive Breast Cancer Risk in African American Women. J Natl Cancer Inst 99(23):1782-1792, 2007.
                    <br />
                    [<a href="http://www.ncbi.nlm.nih.gov/pubmed/11238697?dopt=Abstract">PubMed Abstract</a>]
                </li>
                <li>Matsuno RK, Costantino JP, Ziegler RG, Anderson GL, Li H, Pee D, Gail MH. Projecting Individualized Absolute Invasive Breast Cancer Risk in Asian and Pacific Island American Women. J Natl Cancer Inst 2011. doi:10.1093/jnci/djr154
                </li>                
            </ol>
        </td>
    </tr>
    <tr>
        <td class="hh">
            <a href="#top">Back to Top</a><br />
            <a href="Q00.aspx?restart=true">Begin Risk Calculation</a>
        </td>
    </tr>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BottomLink" runat="Server">
    <tr>
        <td class="h">
            <br />
            <a id="A1" runat="server" href="~/">&lt; Back</a>
        </td>
    </tr>
</asp:Content>
