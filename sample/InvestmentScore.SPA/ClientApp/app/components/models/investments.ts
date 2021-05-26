export class Investment {
    invTitle: string;
    id: number;
    idCombined: number;
    invType: string;
    scores: Score[]
    fundingTeams: string;
    isExcludedTOI: boolean;
}

export class TaxonomyCategory {
    id: number;
    name: string;
    description: string;
    //taxonomyItems: TaxonomyItem[];
    taxonomy: Taxonomy[];
    comments: Taxonomy[];
    label: string;
    total: number;
}

export class Taxonomy {
    id: number;
    categoryId: number;
    itemId: number;
    itemLabel: string;
    itemSort: number;
    valueId: number;
    allocation: number;
    comment: string;
    isAllocation: boolean;
}

export class TaxonomyItem {
    id: number;
    name: string;
    description: string;
    taxonomyCategoryId: number;
    label: string;
}

export class TaxonomyValue {
    id: number;
    value: string;
    numericValue: number;
    taxonomyItemId: number;
    investmentId: number;

}

export class UserDivision {
    id: string;
    email: string;
    divisionId: string;
    division: string;
    employeeId: string;
}

export class Score {
    id: number
    excludeFromScoring
    highestPerforming
    investment
    investmentId
    lowestPerforming
    objective
    performanceAgainstMilestones
    performanceAgainstStrategy
    relativeStrategicImportance
    rationale
    reinvestmentProspects
    keyResultsData
    fundingTeamInput
    scoreDate
    scoreDateUnformatted
    scoreYear
    user
    scoredById
    scoredBy
    createdOn
    createdById
    createdBy
    modifiedOn
    modifiedById
    modifiedBy
    isArchived: boolean
    isExcluded: boolean
    isScoreInEndOfSeason: boolean
    isRationaleRowOver: number
}

export class User {
    id
    department
    displayName
    email
    jobTitle
    loginName
    mobile
    principleType
    sipAddress
    lastUpdated
}

export class DimensionCategories {
    id
    name
    isActive
    dimensionValues
}

export class DimensionValues {
    id
    name
    dimensionCategoryId: number
    displaySortSequence
}

export class ReportCategories {
    id
    name
    displaySortSequence
    isActive
    reports
}

export class Reports {
    id
    name
    reportCategoryId: number
    displaySortSequence
    description
    reportUrl
    isActive
}