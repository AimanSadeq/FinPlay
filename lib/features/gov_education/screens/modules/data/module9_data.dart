import '../gov_module_data.dart';

const module9Data = GovModuleContent(
  id: 9,
  title: 'Compliance & Internal Controls',
  gameTitle: 'Classify the Control',
  gameDescription: 'Classify each control type into the correct category.',
  gameType: GameType.classification,
  slides: [
    // 9.1 Introduction to Compliance
    {
      'title': 'Introduction to Compliance',
      'content':
          'Compliance in government finance refers to the adherence to laws, regulations, standards, and internal policies that govern how public funds are managed, spent, and reported. It represents the foundation of public sector accountability and ensures that government entities operate within legal and ethical boundaries.\n\n'
          'For government organizations, compliance is not merely a legal obligation but a fundamental requirement for maintaining public trust. Citizens expect their government to manage public resources responsibly, transparently, and in accordance with established rules. Every financial transaction, budget decision, and reporting activity must comply with multiple layers of requirements ranging from international accounting standards to local procurement regulations.\n\n'
          'The compliance landscape in government finance is multidimensional, encompassing financial compliance (adherence to accounting standards and budget limits), legal compliance (following laws and regulations), operational compliance (implementing proper procedures and controls), and ethical compliance (maintaining integrity and preventing corruption). Each dimension requires specific knowledge, processes, and oversight mechanisms.\n\n'
          'Non-compliance can have severe consequences including audit qualifications, legal penalties, reputational damage, loss of funding, and erosion of public trust. For government officials, personal accountability may include disciplinary action, criminal charges, or civil liability. Understanding and implementing robust compliance frameworks is therefore essential for all public sector finance professionals.',
      'keyPoint':
          'Compliance means following laws, regulations, standards, and internal policies. It is essential for accountability, transparency, and maintaining public trust. It covers financial, legal, operational, and ethical dimensions. Non-compliance leads to serious consequences for organizations and individuals.',
    },
    // 9.2 Types of Compliance
    {
      'title': 'Types of Compliance',
      'content':
          'Financial compliance requires government entities to follow established accounting standards, maintain accurate records, stay within approved budgets, and report financial information correctly and on time. This includes adherence to IPSAS standards, national accounting frameworks, budget execution rules, and financial reporting requirements. Financial compliance ensures that public funds are accounted for properly and that financial statements provide a true and fair view of the government\'s financial position.\n\n'
          'Legal compliance involves following all applicable laws, regulations, decrees, and legal requirements that govern government operations. This includes public finance laws, procurement regulations, tax laws, employment regulations, and sector-specific legal requirements. Government entities must maintain legal expertise and monitoring systems to ensure ongoing compliance with evolving legal frameworks.\n\n'
          'Operational compliance focuses on implementing and following internal policies, procedures, and operational guidelines that ensure efficient, effective, and controlled operations. This includes approval hierarchies, authorization limits, segregation of duties, documentation requirements, and quality control processes. Operational compliance translates legal and financial requirements into day-to-day practices.\n\n'
          'Ethical compliance requires adherence to codes of conduct, conflict of interest policies, anti-corruption measures, and professional ethics standards. Government officials must maintain integrity, avoid conflicts of interest, refuse bribes or gifts, and act in the public interest at all times. Ethical compliance builds the trust foundation necessary for effective government.',
      'keyPoint':
          'Financial compliance: accounting standards, budget limits, accurate reporting. Legal compliance: laws, regulations, and legal requirements. Operational compliance: policies, procedures, and internal controls. Ethical compliance: codes of conduct, integrity, anti-corruption.',
    },
    // 9.3 Internal Controls (COSO Framework)
    {
      'title': 'Internal Controls (COSO Framework)',
      'content':
          'Internal controls are the policies, procedures, and practices implemented by an organization to ensure operational effectiveness, reliable financial reporting, and compliance with laws and regulations. The Committee of Sponsoring Organizations (COSO) framework is the internationally recognized standard for designing and evaluating internal control systems, consisting of five integrated components.\n\n'
          'The COSO framework\'s five components are: (1) Control Environment - the organizational culture, ethics, and governance structures that set the tone for control consciousness; (2) Risk Assessment - the process of identifying, analyzing, and managing risks to achieving objectives; (3) Control Activities - the specific actions, policies, and procedures that help ensure management directives are carried out (such as approvals, verifications, reconciliations, and segregation of duties); (4) Information and Communication - systems that ensure relevant, quality information is identified, captured, and communicated in a timely manner; and (5) Monitoring Activities - ongoing evaluations that assess the quality and effectiveness of internal controls over time.\n\n'
          'In government finance, effective internal controls prevent errors and fraud, ensure accurate financial reporting, safeguard public assets, promote operational efficiency, and ensure compliance with laws and regulations. Key control activities include segregation of duties (no single person controls all aspects of a transaction), authorization and approval hierarchies, physical controls over assets, documentation requirements, independent verifications and reconciliations, and access controls over systems and information.\n\n'
          'Internal controls must be designed based on risk assessment and should be cost-effective - the cost of controls should not exceed the benefits of risk reduction. Controls must also be regularly monitored and updated as risks, operations, and regulations change. Both management and internal auditors play critical roles in establishing and evaluating internal control effectiveness.',
      'keyPoint':
          'COSO framework: 5 components (Environment, Risk Assessment, Control Activities, Information/Communication, Monitoring). Controls prevent errors and fraud, ensure accurate reporting, and safeguard assets. Key activities: segregation of duties, approvals, verifications, reconciliations. Controls must be risk-based, cost-effective, and regularly monitored.',
    },
    // 9.4 Compliance Framework
    {
      'title': 'Compliance Framework',
      'content':
          'A compliance framework provides the structured approach an organization uses to identify, implement, monitor, and report on compliance requirements. It translates legal and regulatory obligations into operational realities through policies, procedures, responsibilities, and monitoring mechanisms. A well-designed framework ensures that compliance is embedded into daily operations rather than being treated as a separate, periodic activity.\n\n'
          'The framework begins with policies - high-level statements that define what the organization must do to comply with laws, regulations, and standards. Policies establish principles, set boundaries, assign responsibilities, and provide overall direction. They should be clear, approved by appropriate authorities, regularly reviewed, and communicated to all relevant staff.\n\n'
          'Procedures operationalize policies by describing how compliance requirements will be met in practice. They provide step-by-step instructions, specify required documentation, define approval hierarchies, and establish timelines. Procedures should be detailed enough to guide staff actions but flexible enough to accommodate reasonable variations in circumstances.\n\n'
          'The framework also includes monitoring and reporting mechanisms to ensure ongoing compliance. This includes compliance checklists, self-assessment tools, internal audit reviews, management reporting, and external reporting to oversight bodies. Effective monitoring identifies compliance gaps early, enabling corrective action before serious problems develop. Regular reporting keeps management and oversight bodies informed of compliance status and emerging risks.',
      'keyPoint':
          'Compliance framework translates legal obligations into operational practices. Policies define WHAT must be done (high-level requirements). Procedures describe HOW to comply (step-by-step instructions). Monitoring and reporting ensure ongoing compliance and early issue detection.',
    },
    // 9.5 Financial Compliance
    {
      'title': 'Financial Compliance',
      'content':
          'Financial compliance in government requires adherence to accounting standards (such as IPSAS), budget laws, appropriation limits, and financial reporting requirements. Government entities must recognize, measure, and report financial transactions according to prescribed standards, ensuring that financial statements present a true and fair view of the government\'s financial position and performance.\n\n'
          'Budget compliance is a critical dimension of financial compliance. Government entities must operate within approved appropriations, cannot spend funds for purposes not authorized by the legislature, and must maintain systems that prevent over-spending. Real-time budget monitoring, commitment accounting, and expenditure controls are essential to maintain budget compliance throughout the fiscal year.\n\n'
          'Proper authorization is fundamental to financial compliance. Every financial transaction must be authorized by officials with appropriate delegated authority, and authorization limits must be clearly defined and enforced. Spending beyond authorized limits, even if within budget, constitutes non-compliance and may expose officials to personal liability.\n\n'
          'Financial compliance also requires accurate and timely financial reporting to legislative bodies, oversight agencies, and the public. Reports must be prepared according to prescribed formats and deadlines, must be based on reliable accounting records, and must include all required disclosures. Delays or inaccuracies in financial reporting undermine accountability and may indicate control weaknesses or fraud.',
      'keyPoint':
          'Follow IPSAS and national accounting standards for recognition, measurement, and reporting. Maintain budget compliance: stay within appropriations, no unauthorized spending. Ensure proper authorization: all transactions approved by authorized officials within limits. Provide accurate and timely financial reporting to oversight bodies and the public.',
    },
    // 9.6 Procurement Compliance
    {
      'title': 'Procurement Compliance',
      'content':
          'Procurement compliance ensures that government purchasing follows competitive processes, achieves value for money, prevents corruption, and treats vendors fairly. Most jurisdictions have detailed procurement regulations that specify competitive bidding requirements, single-source exceptions, approval thresholds, and evaluation criteria. Government procurement must be transparent, competitive, fair, and documented.\n\n'
          'Competitive bidding requirements typically mandate that purchases above certain thresholds be advertised publicly, that vendors have adequate time to prepare bids, that bids are evaluated against pre-announced criteria, and that contracts are awarded to the most advantageous bid (typically lowest price for compliant bids). Exceptions for single-source procurement are limited to specific circumstances such as emergencies, unique suppliers, or strategic considerations, and must be properly justified and approved.\n\n'
          'Conflict of interest management is critical in procurement. Officials involved in procurement decisions must declare any personal or financial relationships with vendors, must recuse themselves from decisions where conflicts exist, and must not accept gifts, favors, or benefits from vendors. Procurement processes must include conflict of interest declarations and monitoring.\n\n'
          'Contract management compliance requires that contracts are properly authorized, documented, monitored for performance, and closed out appropriately. Payments must be made only for goods and services actually received and accepted, contract variations must be properly approved, and contract files must maintain complete documentation. Poor contract management leads to overpayments, poor quality, and fraud opportunities.',
      'keyPoint':
          'Competitive bidding: transparent, fair processes with adequate vendor time and clear criteria. Value for money: award to most advantageous bid, justify single-source exceptions. Conflict of interest: declarations required, officials must recuse when conflicts exist. Contract management: proper authorization, performance monitoring, payment controls.',
    },
    // 9.7 Fraud Prevention & Detection
    {
      'title': 'Fraud Prevention & Detection',
      'content':
          'Fraud in government involves the deliberate deception or misrepresentation to gain unauthorized benefits or to cause loss to public funds. Common fraud types include procurement fraud (rigged bids, kickbacks, inflated prices), payroll fraud (ghost employees, false overtime, unauthorized bonuses), expense fraud (false receipts, personal expenses claimed), financial reporting fraud (manipulation of accounts), and asset misappropriation (theft of cash or assets). Understanding fraud risks is the first step in prevention.\n\n'
          'The fraud triangle explains why fraud occurs through three elements that must be present: (1) Opportunity - weak controls or override abilities that make fraud possible; (2) Pressure - financial difficulties, lifestyle pressures, or personal problems that motivate fraud; and (3) Rationalization - the mental process that allows the fraudster to justify the behavior ("everyone does it", "I deserve it", "I\'ll pay it back"). Effective fraud prevention addresses all three elements, with primary focus on eliminating opportunities through strong internal controls.\n\n'
          'Fraud prevention strategies include implementing strong internal controls (segregation of duties, authorization requirements, physical controls, access restrictions), conducting thorough background checks on staff handling finances, providing fraud awareness training, establishing clear codes of conduct and consequences, implementing whistleblower hotlines and protection policies, and conducting surprise audits and spot checks. Prevention is far more effective and less costly than detection and investigation.\n\n'
          'Fraud detection involves identifying red flags and investigating suspicious activities. Common red flags include lifestyle inconsistent with income, unusual vendor relationships, duplicate payments, missing documents, overrides of controls, reluctance to take leave, unusual transaction patterns, and complaints from third parties. Organizations should implement continuous monitoring systems, data analytics to identify anomalies, regular reconciliations, independent reviews, and encourage reporting of suspicions. Early detection minimizes losses and demonstrates that fraud will not be tolerated.',
      'keyPoint':
          'Fraud triangle: Opportunity + Pressure + Rationalization must all be present. Prevention strategies: strong controls, background checks, training, whistleblower protection. Red flags: lifestyle inconsistent with income, unusual relationships, missing documents, control overrides. Detection methods: continuous monitoring, data analytics, reconciliations, independent reviews. Prevention is more effective and less costly than detection and investigation.',
    },
    // 9.8 Compliance Monitoring & Reporting
    {
      'title': 'Compliance Monitoring & Reporting',
      'content':
          'Compliance monitoring involves the ongoing assessment of whether the organization is meeting its legal, regulatory, and policy obligations. Effective monitoring combines preventive monitoring (checking before problems occur) and detective monitoring (identifying problems that have occurred). Monitoring should be continuous, systematic, and documented, providing early warning of compliance gaps before they become serious violations.\n\n'
          'Monitoring approaches include management self-assessment (operational managers evaluating their own compliance), compliance checklists (standardized tools for regular review), automated system controls (technology that prevents or detects non-compliance), internal audit reviews (independent assessment by internal auditors), and external audits (independent verification by supreme audit institutions or external auditors). Multiple monitoring layers provide defense in depth.\n\n'
          'Compliance reporting keeps management, governing bodies, and oversight agencies informed of compliance status, emerging risks, and corrective actions. Regular compliance reports should cover key compliance metrics, identified violations or weaknesses, root causes of non-compliance, corrective actions taken or planned, and status of previous recommendations. Reporting should be timely, accurate, and transparent.\n\n'
          'When compliance gaps are identified, organizations must develop and implement corrective action plans. These plans should identify specific actions to address root causes (not just symptoms), assign responsibilities and deadlines, allocate necessary resources, and establish monitoring to ensure effective implementation. Follow-up is essential to verify that corrective actions have resolved the compliance gaps. Failure to address known compliance issues demonstrates management negligence and increases liability.',
      'keyPoint':
          'Continuous monitoring: self-assessment, checklists, automated controls, internal and external audits. Multiple monitoring layers provide defense in depth against compliance failures. Regular reporting: compliance status, violations, root causes, corrective actions. Corrective action plans: address root causes, assign responsibilities, monitor implementation.',
    },
    // 9.9 Ethics & Code of Conduct
    {
      'title': 'Ethics & Code of Conduct',
      'content':
          'A code of conduct establishes the ethical standards and behavioral expectations for government employees and officials. It goes beyond legal compliance to define the values, principles, and conduct that build public trust and organizational integrity. Codes of conduct typically cover conflicts of interest, acceptance of gifts and benefits, use of public resources, confidentiality, political neutrality, and professional behavior. All government employees should receive code of conduct training and acknowledge their commitment to uphold it.\n\n'
          'Conflicts of interest occur when an official\'s personal interests (financial, family, political, or otherwise) could influence their professional decisions or create the appearance of bias. Government officials must identify, declare, and manage conflicts of interest, typically through disclosure requirements, recusal from affected decisions, divestiture of conflicting interests, or reassignment of duties. Even the appearance of conflict can undermine public trust and must be avoided.\n\n'
          'Ethical behavior in government requires that officials act in the public interest, not for personal gain or political advantage. This means making decisions based on merit and public benefit, refusing bribes or improper gifts, protecting confidential information, avoiding nepotism or favoritism, and maintaining political neutrality in service delivery. Government officials are stewards of public resources and public trust.\n\n'
          'Organizations must support ethical behavior through tone at the top (leadership demonstrating ethical commitment), clear policies and guidance, training and communication, mechanisms for seeking ethics advice, protection for those who raise concerns, and consistent enforcement of ethical standards. A strong ethical culture prevents many compliance violations and builds the trust necessary for effective government.',
      'keyPoint':
          'Code of conduct: establishes ethical standards beyond legal compliance. Covers conflicts of interest, gifts, use of resources, confidentiality, political neutrality. Officials must identify, declare, and manage conflicts of interest. Support ethical culture: leadership example, training, advice mechanisms, consistent enforcement.',
    },
    // 9.10 Whistleblower Protection
    {
      'title': 'Whistleblower Protection',
      'content':
          'Whistleblowers are individuals who report suspected wrongdoing, fraud, corruption, or legal violations within their organization. They play a critical role in detecting misconduct that might otherwise remain hidden, as employees often have knowledge of problems that external auditors or oversight bodies cannot easily discover. Effective whistleblower systems encourage reporting, protect reporters from retaliation, and ensure that reports are properly investigated.\n\n'
          'Whistleblower protection laws prohibit retaliation against employees who report suspected wrongdoing in good faith. Protected whistleblowers cannot be fired, demoted, harassed, or otherwise punished for making reports. Protection typically extends to employees who report internally to management or compliance officers, to external oversight bodies such as supreme audit institutions or anti-corruption agencies, and sometimes to media or public disclosure. Protection requirements vary by jurisdiction but generally require that reports be made in good faith (honestly believing the information to be true).\n\n'
          'Organizations should establish confidential reporting mechanisms such as hotlines, secure email addresses, or web portals that allow employees to report concerns safely. Anonymous reporting should be permitted where possible, though investigation may be easier when reporters can be contacted for additional information. All reports should be acknowledged, assessed, and investigated by competent, independent personnel. Reporters should receive feedback on investigation outcomes where appropriate.\n\n'
          'Effective whistleblower systems include clear policies communicated to all staff, multiple reporting channels (internal and external), guarantees of confidentiality and protection from retaliation, timely and thorough investigation processes, feedback to reporters, and consequences for retaliation against whistleblowers. Organizations that foster a speak-up culture and protect those who raise concerns benefit from early detection of problems and demonstrate commitment to integrity.',
      'keyPoint':
          'Whistleblowers report suspected wrongdoing, playing critical role in detecting fraud and corruption. Protection laws prohibit retaliation: no firing, demotion, harassment for good faith reports. Organizations should provide confidential reporting mechanisms: hotlines, secure channels. Effective systems: clear policies, multiple channels, protection guarantees, thorough investigation.',
    },
    // 9.11 Non-Compliance Consequences
    {
      'title': 'Non-Compliance Consequences',
      'content':
          'Financial consequences of non-compliance can include audit qualifications (auditors refusing to provide clean audit opinions), financial penalties and fines imposed by regulatory authorities, loss of grants or funding from donors or higher levels of government, and demands for repayment of improperly spent funds. Government entities may face budget cuts, increased oversight, or suspension of financial authorities. The financial impact extends beyond immediate penalties to include increased audit costs and administrative burden.\n\n'
          'Legal consequences may involve civil lawsuits against the organization or individuals, criminal prosecution for serious violations such as fraud or corruption, administrative sanctions, injunctions preventing certain activities, and mandatory compliance orders. Government officials may face personal legal liability for decisions made outside their authority or in violation of law. In serious cases, officials may face imprisonment, substantial fines, or permanent disqualification from public service.\n\n'
          'Reputational consequences can be severe and long-lasting. Non-compliance damages public trust, undermines the organization\'s credibility, reduces employee morale, and makes it difficult to attract and retain quality staff. Media coverage of compliance failures can damage the reputation of individuals and entire agencies. Loss of reputation makes future operations more difficult as citizens, oversight bodies, and partners view the organization with increased skepticism.\n\n'
          'Personal accountability for government officials includes potential disciplinary action (warnings, suspension, termination), loss of professional certifications or qualifications, difficulty obtaining future employment in government or finance, and personal civil or criminal liability. Officials who authorize or permit non-compliance cannot claim ignorance of requirements as a defense. Professional finance officials have a duty to know and uphold compliance requirements.',
      'keyPoint':
          'Financial: audit qualifications, penalties, loss of funding, repayment demands. Legal: civil lawsuits, criminal prosecution, administrative sanctions, personal liability. Reputational: loss of public trust, media coverage, difficulty attracting staff. Personal: disciplinary action, loss of credentials, employment difficulties, legal liability.',
    },
    // 9.12 Saudi Regulatory Environment
    {
      'title': 'Saudi Regulatory Environment',
      'content':
          'The Kingdom of Saudi Arabia has established a comprehensive regulatory framework for government finance and compliance. The General Auditing Bureau (GAB) serves as the supreme audit institution, providing independent oversight of government financial management and compliance with laws and regulations. GAB conducts financial audits, performance audits, and compliance audits of government entities, and reports findings to the King and the Council of Ministers. GAB\'s audit opinions and recommendations carry significant authority and must be addressed by government entities.\n\n'
          'The Saudi Organization for Certified Public Accountants (SOCPA) regulates the accounting and auditing profession in Saudi Arabia, issues accounting and auditing standards for the Kingdom, and provides professional certification and oversight. SOCPA standards are based on international standards (IFRS and ISA) adapted for the Saudi context. Government entities and their auditors must comply with SOCPA standards and guidance.\n\n'
          'The Capital Market Authority (CMA) regulates securities markets and listed companies, while the Saudi Arabian Monetary Authority (SAMA) oversees banks and financial institutions. While these agencies primarily regulate private sector entities, government-owned enterprises and entities involved in capital markets or banking activities must also comply with CMA and SAMA requirements. These agencies provide additional layers of financial sector oversight and compliance requirements.\n\n'
          'Beyond these specialized agencies, government entities must comply with numerous laws and regulations including the Government Accounting Law, the Tender and Procurement Law, the Civil Service Law, the Anti-Corruption Law, and various ministerial regulations and royal decrees. The regulatory environment continues to evolve as part of Vision 2030 reforms aimed at increasing transparency, efficiency, and accountability in government. Finance professionals must maintain awareness of changing requirements and ensure organizational compliance.',
      'keyPoint':
          'General Auditing Bureau (GAB): supreme audit institution, financial and compliance audits. SOCPA: regulates accounting profession, issues standards based on international frameworks. CMA and SAMA: regulate capital markets and financial institutions. Multiple laws: Government Accounting, Procurement, Civil Service, Anti-Corruption.',
    },
    // 9.13 Key Takeaways
    {
      'title': 'Key Takeaways',
      'content':
          'Compliance is fundamental to government finance, encompassing financial, legal, operational, and ethical dimensions. It is not optional or administrative - it is a legal requirement and professional obligation that protects public resources and maintains citizen trust. Every government finance professional must understand and uphold compliance requirements in their daily work.\n\n'
          'Internal controls based on the COSO framework provide the foundation for compliance. The five integrated components - control environment, risk assessment, control activities, information and communication, and monitoring - work together to prevent errors and fraud, ensure accurate reporting, and support compliance. Segregation of duties, proper authorization, documentation, and reconciliation are critical control activities that must be maintained.\n\n'
          'Fraud prevention requires understanding the fraud triangle (opportunity, pressure, rationalization) and implementing controls that eliminate opportunities. Prevention is far more effective than detection, but organizations also need monitoring systems, red flag awareness, and whistleblower protection to detect fraud early. Ethics, codes of conduct, and speak-up cultures support fraud prevention.\n\n'
          'Non-compliance has serious consequences including financial penalties, legal liability, reputational damage, and personal accountability for officials. The Saudi regulatory environment, including GAB, SOCPA, and various laws, provides comprehensive oversight of government finance. Finance professionals must maintain awareness of requirements, implement robust compliance frameworks, conduct regular monitoring, address gaps promptly, and foster a culture of compliance and integrity throughout their organizations.',
      'keyPoint':
          'Compliance is a legal requirement and professional obligation covering financial, legal, operational, and ethical dimensions. Internal controls (COSO framework) provide the foundation for preventing errors, fraud, and ensuring compliance. Fraud prevention focuses on eliminating opportunities through controls, ethics, and whistleblower protection. Saudi regulatory framework (GAB, SOCPA, laws) provides comprehensive oversight aligned with international standards. Strong compliance culture protects public resources, maintains trust, and supports effective government.',
    },
  ],
  memoryPairs: [
    {'term': 'Compliance', 'definition': 'الامتثال'},
    {'term': 'Internal Controls', 'definition': 'الضوابط الداخلية'},
    {'term': 'COSO Framework', 'definition': 'إطار COSO'},
    {'term': 'Segregation of Duties', 'definition': 'الفصل بين المهام'},
    {'term': 'Fraud Triangle', 'definition': 'مثلث الاحتيال'},
    {'term': 'Whistleblower', 'definition': 'المبلغ عن المخالفات'},
    {'term': 'Due Diligence', 'definition': 'العناية الواجبة'},
    {'term': 'Procurement', 'definition': 'المشتريات'},
    {'term': 'Audit Trail', 'definition': 'مسار التدقيق'},
    {'term': 'Risk Assessment', 'definition': 'تقييم المخاطر'},
    {'term': 'Code of Conduct', 'definition': 'مدونة السلوك'},
    {'term': 'Regulatory Body', 'definition': 'الهيئة التنظيمية'},
    {'term': 'Financial Reporting', 'definition': 'التقارير المالية'},
    {'term': 'Anti-Corruption', 'definition': 'مكافحة الفساد'},
    {'term': 'Accountability', 'definition': 'المساءلة'},
    {'term': 'Transparency', 'definition': 'الشفافية'},
    {'term': 'Governance', 'definition': 'الحوكمة'},
    {'term': 'Fiduciary Duty', 'definition': 'الواجب الائتماني'},
    {'term': 'Sanctions', 'definition': 'العقوبات'},
    {'term': 'Oversight', 'definition': 'الرقابة'},
  ],
  classificationCategories: [
    'Preventive Controls',
    'Detective Controls',
    'Corrective Controls',
  ],
  classificationItems: [
    // Preventive Controls (9 items)
    {'name': 'Segregation of duties', 'category': 'Preventive Controls'},
    {'name': 'Authorization limits', 'category': 'Preventive Controls'},
    {'name': 'Pre-approval requirements', 'category': 'Preventive Controls'},
    {'name': 'Background checks for new hires', 'category': 'Preventive Controls'},
    {'name': 'Access controls and passwords', 'category': 'Preventive Controls'},
    {'name': 'Compliance training programs', 'category': 'Preventive Controls'},
    {'name': 'Mandatory vacation policies', 'category': 'Preventive Controls'},
    {'name': 'Budget spending limits', 'category': 'Preventive Controls'},
    {'name': 'Dual signatures on checks', 'category': 'Preventive Controls'},
    // Detective Controls (9 items)
    {'name': 'Bank reconciliation', 'category': 'Detective Controls'},
    {'name': 'Budget variance analysis', 'category': 'Detective Controls'},
    {'name': 'Physical inventory counts', 'category': 'Detective Controls'},
    {'name': 'Internal audit reviews', 'category': 'Detective Controls'},
    {'name': 'Exception reports', 'category': 'Detective Controls'},
    {'name': 'Data analytics and pattern detection', 'category': 'Detective Controls'},
    {'name': 'Surprise audits', 'category': 'Detective Controls'},
    {'name': 'Transaction monitoring systems', 'category': 'Detective Controls'},
    {'name': 'Account reconciliation reviews', 'category': 'Detective Controls'},
    // Corrective Controls (7 items)
    {'name': 'Disciplinary action for violations', 'category': 'Corrective Controls'},
    {'name': 'Process redesign after failures', 'category': 'Corrective Controls'},
    {'name': 'System patches and updates', 'category': 'Corrective Controls'},
    {'name': 'Disaster recovery plans', 'category': 'Corrective Controls'},
    {'name': 'Fraud remediation programs', 'category': 'Corrective Controls'},
    {'name': 'Policy updates after incidents', 'category': 'Corrective Controls'},
    {'name': 'Corrective action plans', 'category': 'Corrective Controls'},
  ],
  orderingInstruction:
      'Arrange the five compliance framework lifecycle steps in the correct order from start to finish',
  orderingItems: [
    'Identify Regulatory Requirements',
    'Assess Compliance Risks',
    'Design & Implement Controls',
    'Monitor & Test Effectiveness',
    'Report & Remediate',
  ],
  quizQuestions: [
    // Quiz 1: Compliance Fundamentals (7 questions)
    {
      'question': 'What is the primary purpose of compliance in an organization?',
      'options': [
        'To ensure adherence to laws, regulations, and internal policies',
        'To maximize profits at any cost',
        'To eliminate all business risks',
        'To reduce the number of employees',
      ],
      'correctIndex': 0,
      'explanation':
          'Compliance ensures organizations follow applicable laws, regulations, standards, and internal policies to maintain integrity and avoid penalties.',
    },
    {
      'question': 'What does the COSO Framework stand for?',
      'options': [
        'Committee of Strategic Operations',
        'Committee of Sponsoring Organizations of the Treadway Commission',
        'Council of Security and Oversight',
        'Central Office of Systematic Operations',
      ],
      'correctIndex': 1,
      'explanation':
          'COSO stands for the Committee of Sponsoring Organizations of the Treadway Commission, which developed the leading internal control framework.',
    },
    {
      'question': 'Which COSO component establishes the tone at the top and organizational culture?',
      'options': [
        'Risk Assessment',
        'Control Environment',
        'Control Activities',
        'Monitoring Activities',
      ],
      'correctIndex': 1,
      'explanation':
          'The Control Environment is the foundation of COSO, setting organizational tone through ethics, values, management philosophy, and governance structure.',
    },
    {
      'question': 'What is the first stage in a typical compliance framework lifecycle?',
      'options': [
        'Monitoring and testing',
        'Identify and assess requirements',
        'Implement controls',
        'Report results',
      ],
      'correctIndex': 1,
      'explanation':
          'The compliance framework begins with identifying applicable laws, regulations, and standards, then assessing gaps between current state and requirements.',
    },
    {
      'question': 'What is the primary goal of financial compliance?',
      'options': [
        'To maximize revenue at any cost',
        'To ensure accurate financial reporting and adherence to accounting standards',
        'To avoid paying taxes',
        'To eliminate all financial audits',
      ],
      'correctIndex': 1,
      'explanation':
          'Financial compliance ensures accurate, complete, and timely financial reporting in accordance with applicable accounting standards (IFRS, IPSAS, etc.).',
    },
    {
      'question':
          'Which control helps prevent fraud by ensuring no single person has complete control over a financial transaction?',
      'options': [
        'Segregation of duties',
        'Physical security',
        'Data encryption',
        'Password protection',
      ],
      'correctIndex': 0,
      'explanation':
          'Segregation of duties divides critical functions among different people to prevent fraud and errors. No single individual should control all aspects of a transaction.',
    },
    {
      'question':
          'Which type of compliance focuses on following industry-specific regulations set by regulatory bodies?',
      'options': [
        'Legal compliance',
        'Operational compliance',
        'Regulatory compliance',
        'Financial compliance',
      ],
      'correctIndex': 2,
      'explanation':
          'Regulatory compliance involves adhering to rules set by sector-specific regulators (e.g., banking regulations by central banks, securities regulations by market authorities).',
    },
    // Quiz 2: Applied Compliance Scenarios (7 questions)
    {
      'question': 'What are the three elements of the Fraud Triangle?',
      'options': [
        'Opportunity, Pressure, Rationalization',
        'Planning, Execution, Concealment',
        'Detection, Investigation, Prosecution',
        'Prevention, Monitoring, Reporting',
      ],
      'correctIndex': 0,
      'explanation':
          'The Fraud Triangle consists of three elements: Opportunity (weak controls), Pressure (financial or personal need), and Rationalization (justifying the act).',
    },
    {
      'question':
          'An employee both processes payments and approves them. What control weakness exists?',
      'options': [
        'Good efficiency',
        'Lack of segregation of duties',
        'Proper authorization',
        'No weakness',
      ],
      'correctIndex': 1,
      'explanation':
          'This violates segregation of duties - the same person should not both process and approve transactions, as this creates fraud opportunity.',
    },
    {
      'question': 'What is the primary purpose of a Code of Conduct?',
      'options': [
        'To create unnecessary bureaucracy',
        'To define expected ethical behavior and professional standards',
        'To punish employees',
        'To replace all other policies',
      ],
      'correctIndex': 1,
      'explanation':
          'A Code of Conduct sets clear expectations for ethical behavior, professional standards, and acceptable conduct in the organization.',
    },
    {
      'question': 'What protection should whistleblowers receive?',
      'options': [
        'No protection needed',
        'Protection from retaliation and confidentiality',
        'Public exposure of their identity',
        'Immediate dismissal',
      ],
      'correctIndex': 1,
      'explanation':
          'Whistleblowers must be protected from retaliation (firing, demotion, harassment) and their confidentiality must be maintained to encourage reporting.',
    },
    {
      'question':
          'A government official awards a contract to their relative. What issue is this?',
      'options': [
        'Good networking',
        'Conflict of interest',
        'Efficient procurement',
        'No issue',
      ],
      'correctIndex': 1,
      'explanation':
          'Awarding contracts to relatives is a clear conflict of interest that violates procurement compliance and ethics standards.',
    },
    {
      'question': 'What is the role of internal audit in compliance monitoring?',
      'options': [
        'To replace management',
        'To independently assess and report on compliance effectiveness',
        'To perform operational duties',
        'To approve transactions',
      ],
      'correctIndex': 1,
      'explanation':
          'Internal audit provides independent, objective assessment of compliance controls, identifies weaknesses, and recommends improvements.',
    },
    {
      'question': 'What is continuous monitoring in compliance?',
      'options': [
        'Monitoring only during audits',
        'Ongoing, automated monitoring of compliance indicators and controls',
        'Annual compliance checks',
        'Random spot checks',
      ],
      'correctIndex': 1,
      'explanation':
          'Continuous monitoring uses automated tools to constantly monitor compliance indicators, controls, and transactions for real-time detection.',
    },
    // Quiz 3: Cross-cutting Compliance (6 questions)
    {
      'question': 'What is SOCPA in the Saudi regulatory environment?',
      'options': [
        'Saudi Organization for Certified Public Accountants',
        'Saudi Oil and Capital Protection Agency',
        'Saudi Oversight Committee for Public Administration',
        'Saudi Operations Control and Planning Authority',
      ],
      'correctIndex': 0,
      'explanation':
          'SOCPA (Saudi Organization for Certified Public Accountants) regulates accounting and auditing standards in Saudi Arabia.',
    },
    {
      'question':
          'What is Nazaha (National Anti-Corruption Commission) responsible for?',
      'options': [
        'Banking regulation',
        'Combating corruption and enforcing integrity standards',
        'Financial reporting',
        'Stock market oversight',
      ],
      'correctIndex': 1,
      'explanation':
          'Nazaha investigates corruption, enforces integrity standards, and promotes transparency and accountability in public and private sectors.',
    },
    {
      'question': 'What are the potential legal consequences of non-compliance?',
      'options': [
        'No consequences',
        'Fines, penalties, and potential criminal prosecution',
        'Only warnings',
        'Automatic forgiveness',
      ],
      'correctIndex': 1,
      'explanation':
          'Non-compliance can result in financial penalties, legal sanctions, criminal prosecution, and imprisonment depending on severity.',
    },
    {
      'question':
          'What is the difference between a preventive control and a detective control?',
      'options': [
        'No difference',
        'Preventive controls prevent errors before they occur; detective controls identify errors after they occur',
        'They are the same thing',
        'Detective controls are always better',
      ],
      'correctIndex': 1,
      'explanation':
          'Preventive controls stop problems before they occur (e.g., authorization), while detective controls identify problems after they happen (e.g., reconciliation).',
    },
    {
      'question':
          'What is the relationship between compliance and risk management?',
      'options': [
        'They are unrelated',
        'Compliance is a key component of risk management',
        'Risk management eliminates the need for compliance',
        'They conflict with each other',
      ],
      'correctIndex': 1,
      'explanation':
          'Compliance addresses regulatory and legal risks, making it an integral part of comprehensive risk management frameworks.',
    },
    {
      'question': 'Which statement best describes effective compliance?',
      'options': [
        'Compliance is a checkbox exercise',
        'Compliance is an ongoing commitment integrating ethics, controls, monitoring, and continuous improvement',
        'Compliance is only necessary when audited',
        'Compliance eliminates all business risks',
      ],
      'correctIndex': 1,
      'explanation':
          'Effective compliance is an ongoing organizational commitment integrating ethical values, strong controls, active monitoring, and continuous improvement.',
    },
  ],
);
