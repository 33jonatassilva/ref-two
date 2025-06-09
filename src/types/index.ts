
export interface Organization {
  id: string;
  name: string;
  description?: string;
  createdAt: string;
  logo?: string;
}

export interface Team {
  id: string;
  name: string;
  description?: string;
  peopleCount: number;
  createdAt: string;
  organizationId: string;
}

export interface Person {
  id: string;
  name: string;
  email: string;
  teamId: string;
  teamName: string;
  entryDate: string;
  exitDate?: string;
  position: string;
  status: 'active' | 'inactive';
  licenses: License[];
  assets: Asset[];
  responsibilityTermUrl?: string;
  organizationId: string;
}

export interface License {
  id: string;
  name: string;
  description?: string;
  expirationDate: string;
  totalQuantity: number;
  usedQuantity: number;
  cost?: number;
  vendor?: string;
  status: 'active' | 'expired' | 'expiring_soon';
  assignedTo: string[]; // person IDs
  organizationId: string;
}

export interface Asset {
  id: string;
  name: string;
  type: 'notebook' | 'monitor' | 'adapter' | 'other';
  serialNumber: string;
  value: number;
  purchaseDate: string;
  status: 'available' | 'allocated' | 'maintenance' | 'retired';
  assignedTo?: string; // person ID
  assignedToName?: string;
  condition: 'new' | 'good' | 'fair' | 'poor';
  notes?: string;
  organizationId: string;
}

export interface DashboardStats {
  totalPeople: number;
  activePeople: number;
  totalLicenses: number;
  expiringLicenses: number;
  totalAssets: number;
  availableAssets: number;
  totalTeams: number;
}
